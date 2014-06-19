# http://hboon.com/rubymotion-tutorial-for-objective-c-developers/

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  

    @audioController= AEAudioController.alloc.initWithAudioDescription(AEAudioController.nonInterleaved16BitStereoAudioDescription)
    # @audioController.preferredBufferDuration = 0.005
    err = Pointer.new(:object)
    @audioController.start err
    
    file = "audio/loop.m4a".resource_url
    @audio =  AEAudioFilePlayer.audioFilePlayerWithURL(file, audioController: @audioController, error:nil)
    @audio.channelIsMuted = false
    @audio.loop = true
    
    @audio2 =  AEAudioFilePlayer.audioFilePlayerWithURL(file, audioController: @audioController, error:nil)
    @audio2.channelIsMuted = false
    @audio2.loop = true

    
    component_desc = AEAudioComponentDescriptionMake(KAudioUnitManufacturer_Apple, KAudioUnitType_Generator, KAudioUnitSubType_AudioFilePlayer)
    audio_unit_player = AEAudioUnitChannel.alloc.initWithComponentDescription(component_desc, audioController: @audiocontroller, error: nil)
    @audioController.addChannels [@audio]
    @audioController.addChannels audio_unit_player
    
    @window.rootViewController = UIViewController.new
    
    @window.makeKeyAndVisible
    true
    # 
    # sleep 10
    # @audioController.addChannels [@audio2]
    
  end
end


#- REPL debugging
# delegate = UIApplication.sharedApplication.delegate
# delegate.instance_variable_get(:@audioController)

#- Issue with Motion and AudioUnit bridgesupport
# https://groups.google.com/forum/#!topic/rubymotion/-IBIElWiQFI

# - AudioToolbox
# sound_id = Pointer.new('I')
# AudioServicesCreateSystemSoundID("audio/loop.m4a".resource_url, sound_id)
# AudioServicesPlaySystemSound(sound_id[0])
# KPanningMode_SoundField

# - not support for AudioUnit and iOS
# - http://stackoverflow.com/questions/22960236/rubymotion-throwing-nameerror-when-trying-to-create-a-audiocomponentdescription
# - http://stackoverflow.com/questions/14120878/ld-framework-not-found-audiounit

