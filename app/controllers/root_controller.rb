class RootController < UIViewController
  include Config
  attr_accessor :scroll_view

  def viewDidLoad
    super
    setup_scroll_view
    setup_locations
    self.view.addSubview scroll_view
  end

  def setup_scroll_view
    @scroll_view = UIScrollView.alloc.init
    scroll_view.frame = CGRectMake(0, 0, App.window.frame.size.width, App.window.frame.size.height)
    scroll_view.pagingEnabled = false
    scroll_view.backgroundColor = UIColor.blackColor
    scroll_view.contentSize = CGSizeMake(scroll_view.frame.size.width, scroll_view.frame.size.height)
    scroll_view.showsVerticalScrollIndicator = false
    scroll_view.delegate = self
  end

  def setup_locations
    locations.each_with_index do |location, idx|
      scroll_view << location_gif_btn(location, idx)
    end
  end

  def location_animation(location)
    images = gif_images(location).compact
    view   = UIImageView.alloc.initWithFrame(CGRectMake(0, 0, 320, 284))
    view.animationImages = images
    view.animationDuration = 60.0
    view.startAnimating
    view
  end

  def gif_images(location)
    Dir.glob(File.join("buttons/locations".resource_path, location, "*")).map do |path|
      UIImage.imageAtPath(path)
    end
  end

  def location_gif_btn(location, index)
    btn = UIButton.buttonWithType(:custom.uibuttontype)
    images = gif_images(location).compact
    y_axis = index == 0 ? 0 : 284
    btn.setFrame(CGRectMake(0, y_axis, 320, 284))
    btn.tag = index
    btn.addTarget(self, action:"location_action:", forControlEvents: :touch.uicontrolevent)
    btn.setImage(images.first, forState:UIControlStateNormal)
    btn.imageView.animationImages = images
    btn.imageView.animationDuration = 0.9
    btn.alpha = 0
    btn.imageView.startAnimating
    btn.fade_in(duration: 0.9, delay: index.to_f)
  end

  def location_img(location)
    "buttons/locations/#{location}_#{screen_height}".uiimage
  end

  def screen_height
    @screen_height ||= Device.screen.height.to_i
  end

  def location_action(sender)
    location =  locations[sender.tag].to_sym
    #  locations_controller = LocationsController.new(location)
    map_controller = MapController.new(location)
    self.navigationController.pushViewController(map_controller, animated: false)

  end

  def viewWillDisappear(animated)
    super
  end
end
