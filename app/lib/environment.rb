
class Environment
  class <<self
    
    def get(location, channels, &callback)
      channels = format_channels(channels)
      url = "http://liturgy.herokuapp.com?location=#{location}&channels=#{channels}&api_key=#{config["API_KEY"]}"
      BW::HTTP.get("http://google.com") do |response|
        if response.ok?
          resp = fake_response.slice([:add,:remove,:change,:skip].sample)
          callback.call({error: response})
        else
        end
      end
      # fake_response.slice([:add,:remove,:change,:skip].sample)
    end
    
    def format_channels(channels)
      channels
    end
    
    def config
      @config ||= NSBundle.mainBundle.infoDictionary
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