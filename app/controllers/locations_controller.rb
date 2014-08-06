class LocationsController < UIViewController
  attr_accessor :location, :arranger

  def initialize(location)
    puts "<> Initializing #{location}"
    @location = location
    @arranger = Arranger.new(location)
     # get_directions
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    arranger.start if within_distance_of(location)
  end

  # http://stackoverflow.com/questions/14028033/need-assistance-regarding-mkmapitem
  def within_distance_of(location)
    #
    #  Use accessors setup in delegate for current position ...
    #  Arrangement should incude 'noise' if more than X meter from Location
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
