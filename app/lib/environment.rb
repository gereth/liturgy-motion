
class Environment
  class <<self
    
    def get(location, channels, &callback)
      url = config[:api_url] + "?location=#{location}&channels#{channels}"
      BW::HTTP.get(url, credentials: {username: 'api', password: config[:api_key]}) do |resp|
        realization = if resp.ok?
          body = BW::JSON.parse(resp.body)
          App.alert body.to_s
          # fake_response.slice([:add,:remove,:change,:skip].sample) 
        else
          App.alert("Error. Could not load Location. #{resp.inspect}")
          {error: resp}
        end
        callback.call(realization)
      end
    end
    
    def format_channels(channels)
      channels
    end
    
    def config
      @config ||= {
        api_key: config_get("API_KEY"),
        api_url: config_get("API_URL")
      }
    end
    
    def config_get(key)
      NSBundle.mainBundle.infoDictionary[key]
    end
  
    def fake_response
      {
        add: [
          {
            name: "choir", 
            volume: { start: 0.00, stop: 0.88, delay: 0.02, step: 0.01, direction: "up" },
            pan: { start: 0.04, stop: 0.88, delay: 0.32, step: 0.01, direction: "left" }
          }
        ],
        remove: ["choir"],
        change: [
          {
            name: "drums",
            pan: { start: 0.00, stop: 0.88, delay: 0.12, step: 0.11, direction: "right" },
          }
        ],
        skip: [true, false].sample
      }
    end
  end
  
end