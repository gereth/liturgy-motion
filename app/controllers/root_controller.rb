class RootController < UIViewController

  def viewDidLoad
    super
    setup_locations
  end

  def locations
    %w( mt_tabor clinton_division )
  end

  def setup_locations
    locations.each_with_index do |location, idx|
      self.view << location_gif_btn(location, idx)
    end
  end

    def location_animation(location)
      images = gif_images(location).compact
      view =  UIImageView.alloc.initWithFrame(CGRectMake(0, 0, 320, 284))
      view.animationImages = images
      view.animationDuration = 5.0
      view.startAnimating
      view
    end

  def gif_images(location)
    Dir.glob(File.join("buttons/locations".resource_path, location, "*")).map do |path|
      UIImage.imageAtPath(path)
    end
  end

  def location_gif_btn(location, index)
    y_axis = index == 0 ? 0 : 284

    btn = UIButton.buttonWithType(:custom.uibuttontype)
    btn.setFrame(CGRectMake(0, y_axis, 320, 284))
    btn.tag = index
    btn.addTarget(self, action:"location_action:", forControlEvents: :touch.uicontrolevent)
    btn.setImage(gif_images(location).first, forState:UIControlStateNormal)
    btn.imageView.animationImages = gif_images(location).compact
    btn.imageView.animationDuration = 0.5
    btn.imageView.startAnimating
    btn.alpha = 0
    btn.fade_in(duration: 0.9, delay: index.to_f)
  end

  # def location_btn(location, index)
  #   btn    = UIButton.buttonWithType(:custom.uibuttontype)
  #   img    = location_img(location)
  #   y_axis = index == 0 ? 0 : img.size.height
  #   btn.setFrame(CGRectMake(0, y_axis, img.size.width, img.size.height))
  #   btn.tag = index
  #   btn.addTarget(self, action:"location_action:", forControlEvents: :touch.uicontrolevent)
  #   btn.setBackgroundImage(img, forState:UIControlStateNormal)
  #   btn.alpha = 0
  #   btn.fade_in(duration: 0.8, delay: "#{index}".to_f)
  # end

  def location_img(location)
    "buttons/locations/#{location}_#{screen_height}".uiimage
  end

  def screen_height
    @screen_height ||= Device.screen.height.to_i
  end

  def location_action(sender)
    location =  locations[sender.tag].to_sym
    locations_controller = LocationsController.new(location)
    self.navigationController.pushViewController(locations_controller, animated: false)
  end

  def viewWillDisappear(animated)
    super
  end
end
