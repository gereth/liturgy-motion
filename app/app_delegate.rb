
class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UIViewController.new
    @window.makeKeyAndVisible

    @arranger = Arranger.new(:clinton_division)
    @arranger.start
    true
  end

  protected

  def logger(msg)
    puts "#{msg}\n"
  end
end