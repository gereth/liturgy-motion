class MapController < UIViewController
  attr_accessor :current_coordinates, :location

  def initialize(location)
    @current_location = get_current_coordinates
    @location = location
  end

  def get_current_coordinates
    BW::Location.get_once(desired_accuracy: :three_kilometers, purpose: 'We need permission to get your current location for directions') do |result|
      if result.is_a?(CLLocation)
        @current_coordinates = {
          lat: result.latitude,
          long: result.longitude
        }
        puts @current_coordinates.inspect
      else
        puts "Error! #{result[:error]}"
      end
    end
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
  end

  def viewWillDisappear(animated)
    super
  end
end
