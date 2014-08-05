class LocationAnnotation
  attr_accessor :config, :lat, :long

  def initialize(location)
    @config = Config.get(:locations, location)
    @lat, @long = config["coordinates"]
  end

  def title
    config["title"]
  end

  def subtitle
    config["subtitle"]
  end

  def coordinate
    CLLocationCoordinate2D.new.tap do |c|
      c.latitude = lat
      c.longitude = long
    end
  end
end
