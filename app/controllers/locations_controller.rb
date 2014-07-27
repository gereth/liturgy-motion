class LocationsController < UIViewController

  attr_accessor :location, :arranger

  def initialize(location)
    puts "<> Initializing #{location}"
    @location = location
    @arranger = Arranger.new(location)
  end

  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = false
    arranger.start
  end

  def viewWillDisappear(animated)
    super
    arranger.stop
  end
end
