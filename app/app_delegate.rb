# 
# class AppDelegate
# 
#   def application(application, didFinishLaunchingWithOptions:launchOptions)
#     application.setStatusBarStyle(UIStatusBarStyleLightContent)
#     @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
# 
#     nav_bar = UINavigationBar.appearance
#     nav_bar.setTitleTextAttributes({
#       UITextAttributeFont            => UIFont.fontWithName('AvenirNext-Bold', size: 16),
#       UITextAttributeTextShadowColor => :clear.uicolor,
#       UITextAttributeTextColor       => :white.uicolor
#     })
# 
#     root_controller = RootController.alloc.initWithNibName(nil, bundle: nil)
#     nav_controller  = UINavigationController.alloc.initWithRootViewController(root_controller)
#     @window.rootViewController = nav_controller
#     @window.makeKeyAndVisible
#   end
# end


class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
     @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |win|
        win.rootViewController = AsyncController.alloc.init
        win.makeKeyAndVisible
     end
     true
  end
end
class AsyncController < UIViewController
   def thread1
     10.times { |i| NSLog("\t Thread1: %@", i) }
   end
 
   def thread2
     20.times { |i| NSLog("\t\t  Thread2: %@", i) }
   end
 
   def thread3(obj)
     puts obj.keys.join

     # 30.times { |i| NSLog("\t\t\t   Thread3: %@", i) }
   end
   
   def viewDidLoad
      self.view.backgroundColor = UIColor.whiteColor
      @queue = NSOperationQueue.new
      @queue.maxConcurrentOperationCount = 3 
      @queue.name = "threads operation"
      
      operation1 = NSInvocationOperation.alloc.initWithTarget(self, selector: :thread1, object:nil)
      operation2 = NSInvocationOperation.alloc.initWithTarget(self, selector: :thread2, object:nil)
      operation3 = NSInvocationOperation.alloc.initWithTarget(self, selector: :"thread3:", object: {name: "Geoff", balls: "s"})
      
      @queue.addOperation(operation1)
      @queue.addOperation(operation2)
      @queue.addOperation(operation3)
   end
end