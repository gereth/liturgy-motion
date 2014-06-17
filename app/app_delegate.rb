# http://hboon.com/rubymotion-tutorial-for-objective-c-developers/

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @audioController =
      AEAudioController.alloc.initWithAudioDescription(
        AEAudioController.nonInterleaved16BitStereoAudioDescription
      )
    @audioController.start Pointer.new(:object)
    audio = "audio/loop.m4a".resource_url
    @track =  AEAudioFilePlayer.audioFilePlayerWithURL(audio, audioController: @audioController, error:nil)
    @track.loop
    channel = AEBlockChannel.channelWithBlock -> {}
                                                    
    
    true
  end
end


# REPL debugging
# delegate = UIApplication.sharedApplication.delegate
# delegate.instance_variable_get(:@audioController)

