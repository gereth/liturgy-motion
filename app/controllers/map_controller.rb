

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
    map_view.delegate = self
  end

  def viewWillAppear(animated)
    loc_coordinates = CLLocationCoordinate2D.new(location.lat, location.long)
    region = MKCoordinateRegionMake(loc_coordinates, MKCoordinateSpanMake(0.001, 0.001))
    self.view.setRegion(region)
  end

  def viewWillDisappear(animated)
    super
  end

  def mapView(mapView, viewForAnnotation:location)
    view = MKPinAnnotationView.alloc.initWithAnnotation(location, reuseIdentifier:nil)
    view.canShowCallout = true
    view.animatesDrop   = true
    button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
    button.addTarget(self, action: :'showDetails:', forControlEvents:UIControlEventTouchDown)
    view.rightCalloutAccessoryView = button
    view
  end

  def showDetails
    # .openMapsWithItems([location])
  end


  def mapView(mapView, annotationView:view, calloutAccessoryControlTapped:control)
  end

end

# - Directions
# http://www.devfright.com/mkdirections-tutorial/
# http://nshipster.com/mktileoverlay-mkmapsnapshotter-mkdirections/
# http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
# https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/LocationAwarenessPG/ProvidingDirections/ProvidingDirections.html#//apple_ref/doc/uid/TP40009497-CH8-SW5
