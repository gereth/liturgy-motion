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

    auto_pan @audio, 0.00, 0.94, 0.110
    @window.rootViewController = UIViewController.new
    @window.makeKeyAndVisible
    true
  end
  
  protected

  def load_audio(path, opts={})
    audio = AEAudioFilePlayer.audioFilePlayerWithURL(path.resource_url, audioController: @audio_controller, error:nil)
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
  
  #  0.20 = 20 seconds from start to finish, e.g., C to R
  def auto_pan(channel, start, finish, delay=0.209)
    serial_queue = Dispatch::Queue.new("serial_queue") 
    (start..finish).step(0.01).to_a.each do |pan|
      serial_queue.sync do
        channel.pan = pan
        sleep(delay)
        puts "time: #{channel.currentTime} pan: #{pan} delay: #{delay}"
      end
    end
  end

  def auto_fade(channel, start, finish, speed)
  end
  

  def instance(name)
    App.delegate.instance_variable_get(:"@#{name}")
  end
end