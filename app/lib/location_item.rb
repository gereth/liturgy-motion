class LocationItem
  attr_accessor :config, :lat, :long, :key

  def initialize(key)
    @config = Config.get(:locations, key)
    @lat, @long = config["coordinates"]
    @key = key
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
