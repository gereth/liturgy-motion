class RootController < UIViewController

  def viewDidLoad
    super
    setup_locations
  end

  def locations
    %w( clinton_division mount_tabor )
  end

  def setup_locations
    locations.each do |location|
      self.view << location_btn(location)
    end
  end

  def location_btn(location, index)
    btn    = UIButton.buttonWithType(:custom.uibuttontype)
    img    = location_img(location).uiimage
    y_axis = index == 0 ? 0 : img.size.height

    btn.setFrame(CGRectMake(0, y_axis, img.size.width, img.size.height))
    btn.tag = index
    btn.addTarget(self, action:"location_action:", forControlEvents: :touch.uicontrolevent)
    btn.setBackgroundImage(img, forState:UIControlStateNormal)
    btn.alpha = 0
    btn.fade_in(duration: 0.8, delay: "#{index}".to_f)
  end

  def location_img(location)
    "buttons/locations/#{location}_#{screen_height}"
  end

  def screen_height
    @screen_height ||= Device.screen.height.to_i
  end

  def location_action(sender)
    location =  location[sender.tag].to_sym
    locations_controller = LocationsController.new(location)
    self.navigationController.pushViewController(locations_controller, animated: false)
  end

  def viewWillDisappear(animated)
    super
  end
end
