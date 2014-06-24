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
    @audio_controller.addChannels [@audio, @audio2]
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
    
    automate_pan 0.00, 0.56, 0.01, @audio, :right, 0.50
    automate_volume 0.01, 0.99, 0.01, @audio, :up, 0.80
    
    automate_pan -0.99, -0.58, 0.01, @audio2, :left, 0.18
    automate_volume 0.01, 0.68, 0.02, @audio2, :up, 0.80
    
    monitor_audio
    true

  end

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
  
  # "[channel - #{channel}] time: #{channel.currentTime.round(2)} volume: #{channel.volume.round(2)} pan: #{channel.pan.round(2)}"
  def monitor_audio
    EM.add_periodic_timer 3.0 do
      %w( audio audio2 ).each do |channel|
        a = instance(channel)
        logger visualize_channel(a) 
      end
    end
  end
  
  def visualize_channel(channel)
    [:pan, :volume].map do |att|
      field = if att == :pan
        right = (0.00..0.99).step(0.01).to_a
        left  = right.reverse.map{ |f| -f }
        (left + right)
      else
        (0.01..1.00).step(0.01).to_a
      end
      
      field.map{|f| f.round(2)}.uniq.map do |f|
        if channel.send(att).round(2) == f.round(2)
          f
        elsif f == 0.0
          "|"
        else
          "."
        end
      end.join
    end
  end
  
  protected
  
  def logger(msg)
    puts msg
    puts "\n\n"
  end
  
  def range(s, f, step=0.01)
    (s..f).step(step).to_a
  end

  def instance(name)
    App.delegate.instance_variable_get(:"@#{name}")
  end
  
end