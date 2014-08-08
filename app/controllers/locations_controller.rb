class LocationsController < UIViewController
  attr_accessor :location, :arranger

  def initialize(location)
    puts "<> Initializing #{location}"
    @location = location
    @arranger = Arranger.new(location)
    @current_coordinates ||= UIApplication.sharedApplication.delegate.current_coordinates
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    arranger.start if within_distance_of(location)
  end

  # http://stackoverflow.com/questions/14028033/need-assistance-regarding-mkmapitem
  def within_distance_of(location)
  end

  def get_directions
    location_item = LocationItem.new(location)
    placemark = MKPlacemark.alloc.initWithCoordinate(location_item.coordinate, addressDictionary:location_item.address )
    map_item  = MKMapItem.alloc.initWithPlacemark(placemark)
    map_item.name = location_item.name
    opts = {}
    map_item.openInMapsWithLaunchOptions(opts)
  end

  def viewWillDisappear(animated)
    super
    arranger.stop
  end
end
