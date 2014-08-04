class Location
  attr_accessor :lat, :long, :name, :address

  def initialize(location)
    location = Config.get(:locations, location)
    @lat, @long = location[:coordinates]
    @name = location[:name]
    @address = location[:address]
  end

  def title
    [name, address].join(" \n ")
  end

  def coordinate
    CLLocationCoordinate2D.new.tap do |c|
      c.latitude = lat
      c.longitude = long
    end
  end
end
