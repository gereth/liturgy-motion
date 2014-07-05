# TODO

# root controller with scrolling nav
# minimal player controls with actions to pause and play
# directions to each exhibit
# rewrite with AVAudioEngine

class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    locations_controller = LocationsController.alloc.init
    nav_controller       = UINavigationController.alloc.initWithRootViewController(locations_controller)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible    
    true
  end
end