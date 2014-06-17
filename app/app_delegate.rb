class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    AEAudioController.alloc.initWithAudioDescription(AEAudioController.nonInterleaved16BitStereoAudioDescription)
    
    true
  end
end
