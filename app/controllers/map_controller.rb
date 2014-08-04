

class MapController < UIViewController
  attr_accessor :location

  def initialize(location)
    @location = Location.new(location)
  end

  def get_current_coordinates
    BW::Location.get_once(desired_accuracy: :three_kilometers, purpose: Config.get(:en, :permission)) do |res|
      if res.is_a?(CLLocation)
        @current_coordinates = {
          lat: res.latitude,
          long: res.longitude
        }
      else
        App.alert "Error! #{res[:error]}"
      end
    end
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    map_view = MKMapView.alloc.initWithFrame(self.view.bounds)
    map_view.mapType = MKMapTypeHybrid
    self.view = map_view
    map_view.addAnnotation location
  end

  def viewWillAppear(animated)
    loc_coordinates = CLLocationCoordinate2D.new(location.lat, location.long)
    region = MKCoordinateRegionMake(loc_coordinates, MKCoordinateSpanMake(0.001, 0.001))
    self.view.setRegion(region)
  end

  def viewWillDisappear(animated)
    super
  end

  ViewIdentifier = 'ViewIdentifier'
  def mapView(mapView, viewForAnnotation:location)
    if view = mapView.dequeueReusableAnnotationViewWithIdentifier(ViewIdentifier)
      view.annotation = location
    else
      view = MKPinAnnotationView.alloc.initWithAnnotation(location, reuseIdentifier:ViewIdentifier)
      view.canShowCallout = true
      view.animatesDrop   = true
      button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
      button.addTarget(self, action: :'showDetails:', forControlEvents:UIControlEventTouchUpInside)
      view.rightCalloutAccessoryView = button
    end
    view
  end
end


# - Directions
# http://nshipster.com/mktileoverlay-mkmapsnapshotter-mkdirections/
# http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
