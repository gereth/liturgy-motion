
class AppDelegate
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
    true
  end

  def current_coordinates
    @location_manager ||= CLLocationManager.alloc.init.tap do |lm|
      lm.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      lm.startUpdatingLocation
      lm.delegate = self
    end
    ld = @location_manager.location.locationDescription
    lat, long = ld[/(\d+.\d+)(.*?)\d+.\d+/].split.map(&:to_f)
    CLLocationCoordinate2D.new lat, long
  end

end
