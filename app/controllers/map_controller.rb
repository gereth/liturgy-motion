# 
#
# class MapController < UIViewController
#   attr_accessor :annotation, :coordinates
#
#   def initialize(location)
#     @annotation = LocationAnnotation.new(location)
#     @coordinates = CLLocationCoordinate2D.new(annotation.lat, annotation.long)
#   end
#
#   # Move to arranger
#   def get_current_coordinates
#     BW::Location.get_once(desired_accuracy: :three_kilometers, purpose: Config.get(:en, :permission)) do |res|
#       if res.is_a?(CLLocation)
#         @current_coordinates = {
#           lat: res.latitude,
#           long: res.longitude
#         }
#       else
#         App.alert "Error! #{res[:error]}"
#       end
#     end
#   end
#
#   def viewDidLoad
#     super
#     self.navigationController.navigationBar.hidden = false
#     map_view = MKMapView.alloc.initWithFrame(self.view.bounds)
#     map_view.mapType = MKMapTypeHybrid
#     self.view = map_view
#     map_view.addAnnotation annotation
#     map_view.delegate = self
#   end
#
#   def viewWillAppear(animated)
#     region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.001, 0.001))
#     self.view.setRegion(region)
#   end
#
#   def viewWillDisappear(animated)
#     super
#   end
#
#   def mapView(mapView, viewForAnnotation:annotation)
#     view = MKPinAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:nil)
#     view.canShowCallout = true
#     view.pinColor = MKPinAnnotationColorPurple
#     button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
#     button.addTarget(self, action: :'get_directions', forControlEvents:UIControlEventTouchDown)
#     view.rightCalloutAccessoryView = button
#     view
#   end
#
#   def get_directions
#     puts "Getting directions: %s" % annotation.config["name"]
#     placemark = MKPlacemark.alloc.initWithCoordinate(annotation.coordinate, addressDictionary:nil)
#     map_item  = MKMapItem.alloc.initWithPlacemark(placemark)
#     map_item.name = annotation.config["name"]
#     options   = {}
#     map_item.openInMapsWithLaunchOptions(options)
#   end
#
#   def mapView(mapView, annotationView:view, calloutAccessoryControlTapped:control)
#   end
#
# end
#
# # - Directions
# # http://www.devfright.com/mkdirections-tutorial/
# # http://nshipster.com/mktileoverlay-mkmapsnapshotter-mkdirections/
# # http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
# # https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/LocationAwarenessPG/ProvidingDirections/ProvidingDirections.html#//apple_ref/doc/uid/TP40009497-CH8-SW5
