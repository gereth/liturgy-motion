class Realization
  class <<self

    def get(location, current_distance, channels, &callback)
      json = BW::JSON.generate(
        {
          location: location.key,
          current_distance: current_distance,
          lat: location.coordinate.latitude,
          long: location.coordinate.longitude,
          channels: channels
        }
      )
      BW::HTTP.post(config[:api_url], payload: json, credentials: {username: 'api', password: config[:api_key]}) do |resp|
        realization = if resp.ok?
          BW::JSON.parse(resp.body)
        else
          {error: resp}
        end
        callback.call realization
      end
    end

    def config
      @config ||= {
        api_key: env_get("API_KEY"),
        api_url: env_get("API_URL")
      }
    end

    # - Dotenv.load.each{ |k,v| app.info_plist[k] = v }
    def env_get(key)
      NSBundle.mainBundle.infoDictionary[key]
    end
  end

end
