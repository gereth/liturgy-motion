class LocationsController < UIViewController

  attr_accessor :location

  def initialize(location)
    puts "<> Initializing #{location}"
    @location = location
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    arranger = Arranger.new(location)
    arranger.start
  end

  def viewWillDisappear(animated)
    super
  end
end
