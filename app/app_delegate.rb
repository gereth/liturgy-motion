
class AppDelegate
  include AudioHelper
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UIViewController.new
    @window.makeKeyAndVisible

    load_audio_channels_for :clinton_division
    true
  end

  protected

  def logger(msg)
    puts "#{msg}\n"
  end
end