
class Environment
  class <<self
    
    def get(location, playing, &callback)
      channels = playing.map{|c| c[:name]}
      params   = "location=#{location}&channels=#{channels}"
      url      = [ config[:base_url], params].join("?")
      BW::HTTP.get(url, credentials: {username: 'api', password: config[:api_key]}) do |resp|
        realization = if resp.ok?
          App.alert(BW::JSON.parse(resp.body).keys.join(","))
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
        api_key: NSBundle.mainBundle.infoDictionary["API_KEY"],
        base_url: "http://localhost:9292/api/forecast.json",
      }
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