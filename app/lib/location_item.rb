class LocationItem
  attr_accessor :config, :lat, :long

  def initialize(location)
    @config = Config.get(:locations, location)
    @lat, @long = config["coordinates"]
  end

  def coordinate
    CLLocationCoordinate2D.new.tap do |c|
      c.latitude = lat
      c.longitude = long
    end
  end

  [:name, :address].each do |name|
    define_method(name) do
      config[name]
    end
  end
end
