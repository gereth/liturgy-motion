# http://hboon.com/rubymotion-tutorial-for-objective-c-developers/

class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Audio Controller
    #
    @audio_controller= AEAudioController.alloc.initWithAudioDescription(
      AEAudioController.nonInterleaved16BitStereoAudioDescription
    )
    @audio_controller.start au_controller_error
    
    # Player & Channels
    #
    audio_component = AEAudioComponentDescriptionMake(
      KAudioUnitManufacturer_Apple, 
      KAudioUnitType_Generator, 
      KAudioUnitSubType_AudioFilePlayer
    )
    audio_unit_player = AEAudioUnitChannel.alloc.initWithComponentDescription(
      audio_component, 
      audioController: @audio_controller, 
      error: au_player_error
    )
    @audio = load_audio "audio/loop.m4a"
    @audio2 = load_audio "audio/loop.m4a"
    @audio2.currentTime = 10
    @audio.loop = true
    @audio2.pan = -0.90
    @audio_controller.addChannels [@audio]
    @audio_controller.addChannels [audio_unit_player]

    # Limiter
    #
    @limiter = AELimiterFilter.alloc.initWithAudioController(@audio_controller)
    @limiter.level  = 10.0
    @limiter.hold   = 100.0
    @limiter.attack = 0.01

    # Filter
    #
    # delay_component = AEAudioComponentDescriptionMake(
    #   KAudioUnitManufacturer_Apple, 
    #   KAudioUnitType_Effect,
    #   KAudioUnitSubType_Delay
    # )
    # @ae_filter = AEAudioUnitFilter.alloc.initWithComponentDescription(delay_component, audioController:@audio_controller, error: au_filter_error)

    
    @window.rootViewController = UIViewController.new
    @window.makeKeyAndVisible
    
    
    # monitor_audio

    automate_pan 0.00, 0.56, 0.01, @audio, :right, 0.50
    automate_volume 0.01, 0.99, 0.01, @audio, :up, 0.80
    monitor_audio
    true

  end

  # :automate_volume, :automate_pan
  #
  %w( volume pan).each do |kind|
    define_method("automate_#{kind}".to_sym) do |start, finish, step, channel, direction, delay|
      serial_queue = Dispatch::Queue.concurrent("serial_queue_#{rand}")
      serial_queue.async do
        puts "{queue} #{kind} Starting\n"
        range(start, finish, step).each do |float|
          plus_minus = direction == :right || :up ? 1 : -1
          param = ((float + 0.02) * plus_minus).round(2)
          channel.__send__("#{kind}=", param)
          sleep(delay)
        end
      end
    end
  end
  
  def load_audio(path, opts={})
    audio = AEAudioFilePlayer.audioFilePlayerWithURL(
      path.resource_url, 
      audioController: @audio_controller, 
      error:nil
    )
    audio.channelIsMuted = false
    audio.currentTime = 0.30
    audio.loop = opts[:loop] || true
    audio
  end
  
  %w( au_controller au_player au_filter).each do |name|
    define_method("#{name}_error") do
      Pointer.new(:object)
    end
  end
  
  def monitor_audio
    EM.add_periodic_timer 3.0 do
      %w( audio audio2 ).each do |channel|
        a = instance(channel)
        logger "[channel - #{channel}] time: #{a.currentTime.round(2)} volume: #{a.volume.round(2)} pan: #{a.pan.round(2)}"
        logger visualize_channel(a, :pan)     
        logger visualize_channel(a, :volume)        
           
      end
    end
  end
  
  def logger(msg)
    puts msg
    puts "\n\n"
  end
  
  def visualize_channel(channel, att)
    field = if att == :pan
      right = (0.00..0.99).step(0.01).to_a
      left  = right.reverse.map{ |f| -f }
      (left + right)
    else
      (0.01..1.00).step(0.01).to_a
    end
    
    field.map{|f| f.round(2)}.uniq.map do |f|
      if channel.send(att).round(2) == f.round(2)
        "#{f}"
      else
        "."
      end
    end.join
  end
  
  def range(s, f, step=0.01)
    (s..f).step(step).to_a
  end

  def instance(name)
    App.delegate.instance_variable_get(:"@#{name}")
  end
  
  def get_current(att, object)
    puts att.send(object)
  end
end