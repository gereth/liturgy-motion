class Arranger
  include AudioHelper
  
  attr_accessor :channels, :location, :poller

  def initialize(location)
    @location = location
    @channels = load_audio_channels_for(location)
    @poller   = EM.add_periodic_timer(15.0) { poll_and_realize }
  end
  
  def playing
    channels.select do |channel|
      audio_controller.channels.include?(channel[:channel])
    end
  end
  
  def start
    start_audio_controller unless audio_controller.running
    audio_controller.addChannels [audio_channel_for("choir") ]
    poll_and_realize
  end
    
  def realize(resp)
    if resp[:skip]
      puts "skipping realization"
    else
      # add resp[:add]
      # remove resp[:remove]
      # change resp[:change]
    end
  end
  
  def audio_channel_for(name)
    channels.find{|c| c[:name] == name }[:channel]
  end
  
  def remove(remove)
    puts "<> Removing: #{remove.inspect}"
    remove.each do |name|
      puts name
      channel = audio_channel_for(name)
      # skip if playing?
      volume(channel.volume, 0.00, 0.08, channel, 0.10, 1) do
        puts "removed!"
        audio_controller.removeChannels [channel]
      end
    end
  end
  
    
  def add(add)
  end
  
  def change(change)
    
  end
  
  def poll_and_realize
    resp = Environment.get(location, playing)
    realize(resp)
  end
  
  def cancel_poller
    EM.cancel_timer(poller)
  end
end

