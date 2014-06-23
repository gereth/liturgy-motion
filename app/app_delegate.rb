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
    @audio.loop = true
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
    true
  end

  # :automate_volume, :automate_pan
  #
  %w( volume pan).each do |kind|
    define_method("automate_#{kind}".to_sym) do |start, finish, step, channel, direction, delay|
      serial_queue = Dispatch::Queue.new("serial_queue_#{rand}")
      range(start, finish, step).each do |float|
        serial_queue.sync do
          plus_minus = direction == :right || :up ? 1 : -1
          param = (float + 0.02) * plus_minus
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