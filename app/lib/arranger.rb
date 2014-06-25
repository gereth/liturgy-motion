class Arranger
  include AudioHelper
  
  attr_accessor :channels, :location, :poller
  
  def initialize(location)
    @channels = load_audio_channels_for(location)      
    @poller   = EM.add_periodic_timer(5.0) { poll(location) }
  end
  
  def start
    start_audio_controller
  end

  def poll(location)
    Environment.get(location, channels) do |response|
      puts response
    end
  end
  
  def cancel_poller
    EM.cancel_timer(poller)
  end
  
end