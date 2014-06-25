class Environment
  class <<self
    
    def get(location, channels, &block)
      yield fake_response if block_given?
    end
  
    def fake_response
      {
        add: [
          {
            name: "choir", 
            volume: {from: 0.44, to: 0.68}, 
            pan: {from: 0.00, to: 0.11}
          }
        ],
        remove: ["violin"]
      }
    end
  end
end