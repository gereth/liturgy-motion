class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @audioController =
      AEAudioController.alloc.initWithAudioDescription(
        AEAudioController.nonInterleaved16BitStereoAudioDescription
      )
    
    true
  end
end


# REPL debugging
# delegate = UIApplication.sharedApplication.delegate
# delegate.instance_variable_get(:@audioController)

