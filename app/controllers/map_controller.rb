# todo
# - annotate map with all locations.  Might be good to abstract locations in a hash w/ coords then include
# - pass the directions request
# - ability to navigate back to LocationController.new(location)


class MapController < UIViewController
  attr_accessor :current_coordinates, :location

  def initialize(location)
    @current_location = get_current_coordinates
    @location         = location
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

  def get_directions
    # http://nshipster.com/mktileoverlay-mkmapsnapshotter-mkdirections/
    # http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false

  end

  def viewWillDisappear(animated)
    super
  end
end
