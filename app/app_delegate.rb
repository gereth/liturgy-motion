# http://hboon.com/rubymotion-tutorial-for-objective-c-developers/

class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Audio Controller
    @audio_controller= AEAudioController.alloc.initWithAudioDescription(
      AEAudioController.nonInterleaved16BitStereoAudioDescription
    )
    @audio_controller.start au_controller_error
    
    # Player & Channels
    audio_component = AEAudioComponentDescriptionMake(
      KAudioUnitManufacturer_Apple, 
      KAudioUnitType_Generator, 
      KAudioUnitSubType_AudioFilePlayer
    )
    audio_unit_player = AEAudioUnitChannel.alloc.initWithComponentDescription(
      audio_component, 
      audioController: @audiocontroller, 
      error: au_player_error
    )
    @audio = load_audio "audio/loop.m4a"
    @audio_controller.addChannels [@audio]
    @audio_controller.addChannels audio_unit_player
    
    # Filter
    delay_component = AEAudioComponentDescriptionMake(
      KAudioUnitManufacturer_Apple, 
      KAudioUnitType_Effect,
      KAudioUnitSubType_Delay
    )
    @ae_filter = AEAudioUnitFilter.alloc.initWithComponentDescription(delay_component, audioController:@audio_controller, error: au_filter_error)
    
    @limiter = AELimiterFilter.alloc.initWithAudioController(@audio_controller)
    @limiter.level = 100.0
    
    @window.rootViewController = UIViewController.new
    @window.makeKeyAndVisible
    true
  end
  
  protected
  
  def load_audio(path, opts={})
    audio = AEAudioFilePlayer.audioFilePlayerWithURL(path.resource_url, audioController: @audio_controller, error:nil)
    audio.channelIsMuted = false
    audio.loop = opts[:loop] || false
    audio
  end
  
  %w( au_controller au_player au_filter).each do |name|
    define_method("#{name}_error") do
      Pointer.new(:object)
    end
  end
  
  def auto_pan(channel, origin, dest, speed=0.033)
    (origin.to_f..dest).step(0.01).to_a.each do |pan|
      puts "panning: #{pan}"
      channel.pan = pan
    end
  end
  
  def instance(name)
    App.delegate.instance_variable_get(:"@#{name}")
  end
    
end

# https://groups.google.com/forum/#!topic/rubymotion/-IBIElWiQFI

# - AudioToolbox
# sound_id = Pointer.new('I')
# AudioServicesCreateSystemSoundID("audio/loop.m4a".resource_url, sound_id)
# AudioServicesPlaySystemSound(sound_id[0])
# KPanningMode_SoundField

# - not support for AudioUnit and iOS
# - http://stackoverflow.com/questions/22960236/rubymotion-throwing-nameerror-when-trying-to-create-a-audiocomponentdescription
# - http://stackoverflow.com/questions/14120878/ld-framework-not-found-audiounit

# - Compression
# http://club15cc.com/code/ios/mixing-audio-without-clipping-limiters-etc
# https://developer.apple.com/library/ios/documentation/AudioUnit/Reference/AudioUnitParametersReference/Reference/reference.html#//apple_ref/doc/uid/TP40007290-CH1-SW1

