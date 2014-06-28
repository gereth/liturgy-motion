
class Environment
  class <<self
    
    def get(location, channels)
      fake_response.slice([:add,:remove,:change,:skip].sample)
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