class Environment
  class <<self
    
    def get(location, channels)
      # activity_indicator do ..
      fake_response
    end
  
    def fake_response
      {
        add: [
          {
            name: "choir", 
            volume: {from: 0.44, to: 0.68, delay: 0.00}, 
            pan: {from: 0.00, to: 0.11, delay: 0.00}
          }
        ],
        remove: ["choir"],
        change: [
          {
            name: "drums",
            pan: {from: 0.01, to: 0.23, delay: 0.012, direction: -1}
          }
        ]
      }
      # { skip: true } -> skip
    end
  end
end