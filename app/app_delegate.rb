
class AppDelegate
  include Config
  include MapKit
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.setStatusBarStyle(UIStatusBarStyleLightContent)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    nav_bar = UINavigationBar.appearance
    nav_bar.setTitleTextAttributes({
      UITextAttributeFont            => UIFont.fontWithName('AvenirNext-Bold', size: 16),
      UITextAttributeTextShadowColor => :clear.uicolor,
      UITextAttributeTextColor       => :white.uicolor
    })

    root_controller = RootController.alloc.initWithNibName(nil, bundle: nil)
    nav_controller  = UINavigationController.alloc.initWithRootViewController(root_controller)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
  end
end
