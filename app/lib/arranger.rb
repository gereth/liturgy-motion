class Arranger
  include AudioHelper
  
  attr_accessor :channels, :location, :poller

  def initialize(location)
    @location = location
    @channels = load_audio_channels_for(location)
    # @poller   = EM.add_periodic_timer(60.0) { poll_and_realize }
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
      add resp[:add]
      # remove resp[:remove] 
      # change resp[:change] 
    end
  end
  
  def audio_channel_for(name)
    channels.find{|c| c[:name] == name }[:channel]
  end
  
  def remove(remove)
    remove.each do |name|
      puts "<> Removing channel: #{obj[:name]}"
      channel = audio_channel_for(name)
      opts = {direction: "down", start: channel.volume, stop: 0.00 }
      volume(opts, channel, 0.89) do |audio|
        audio_controller.removeChannels([audio])
      end
    end
  end
    
  def add(add)
    add.each do |obj|
      puts "<> Adding channel: #{obj[:name]}"
      channel = audio_channel_for(obj[:name])
      channel.volume = 0.0 # obj[:volume][:start]
      channel.pan = obj[:pan][:start]
      audio_controller.addChannels([channel])
      volume obj[:volume], channel
      pan obj[:pan], channel
    end
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

