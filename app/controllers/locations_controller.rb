class LocationsController < UIViewController
  attr_accessor :location, :arranger

  def initialize(location)
    puts "<> Initializing - #{location.name}"
    @location = location
    @arranger = Arranger.new(location)
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    arranger.start
  end

  def get_directions
    placemark = MKPlacemark.alloc.initWithCoordinate(location.coordinate, addressDictionary:location.address )
    map_item  = MKMapItem.alloc.initWithPlacemark(placemark)
    map_item.name = location.name
    opts = {}
    map_item.openInMapsWithLaunchOptions(opts)
  end

  def viewWillDisappear(animated)
    super
    arranger.stop
  end
end
