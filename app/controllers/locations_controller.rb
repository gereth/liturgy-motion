class LocationsController < UIViewController
  
  def viewDidLoad
    super
    add_locations
  end

  def add_locations
    # ...
    @arranger = Arranger.new(:clinton_division)
    @arranger.start
  end
end