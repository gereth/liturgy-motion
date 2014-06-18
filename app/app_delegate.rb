# http://hboon.com/rubymotion-tutorial-for-objective-c-developers/

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  

    @audioController = WeakRef.new(
      AEAudioController.alloc.initWithAudioDescription(
        AEAudioController.nonInterleaved16BitStereoAudioDescription
      )
    )
    @audioController.preferredBufferDuration = 0.005
    err = Pointer.new(:object)
    @audioController.start err
    
    file = "audio/loop.m4a".resource_url
    @audio =  AEAudioFilePlayer.audioFilePlayerWithURL(file, audioController: @audioController, error:nil)
    @audio.loop = true
    
    # component_desc = AEAudioComponentDescriptionMake(
    #     KAudioUnitManufacturer_Apple, 
    #     KAudioUnitType_Generator, 
    #     KAudioUnitSubType_AudioFilePlayer
    # )
    # oUnitChannel.alloc.initWithComponentDescription(component_desc, audioController: @audiocontroller, error: nil)
    # @window.makeKeyAndVisible
    true
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


