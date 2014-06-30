class LocationsController < UIViewController
  
  def viewDidLoad
    super
    setup_locations
  end

  def setup_locations
    # ...
    
    @arranger = Arranger.new(:clinton_division)
    @arranger.start
  end
end