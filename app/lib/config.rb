module Config
  extend self

  def yml
    @yml ||= YAML::load(NSMutableData.dataWithContentsOfURL("config.yml".resource_url).to_s)
  end

  def get(*keys)
    keys.inject(yml) { |yml,key| yml[key]}
  end

  def locations
    get(:locations).keys
  end

  def coordinates(location)
    get(:locations, location.to_sym, :coordinates)
  end
end
