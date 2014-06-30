class Arranger
  include AudioHelper
  
  attr_accessor :channels, :location, :poller

  def initialize(location)
    @location = location
    @channels = load_audio_channels_for(location)
    @poller   = EM.add_periodic_timer(25.0) { poll_and_realize }
  end
  
  def playing
    channels.select do |channel|
      audio_controller.channels.include?(channel[:channel])
    end
  end
  
  def start
    start_audio_controller unless audio_controller.running
    poll_and_realize
  end
    
  def realize(resp)
    if resp[:skip]
      puts "[*] Skipping realization"
    elsif resp[:error]
      puts "[*] Error. Cancelling poller."
      cancel_poller
    else
      puts "[+] Starting realization: #{resp.inspect}"
      add resp       
      remove resp 
      change resp
    end
  end
  
  def audio_channel_for(name)
    (channels.find{|c| c[:name] == name} || {})[:channel]
  end
  
  def channel_is_playing(channel)
    channel.channelIsPlaying && channel.currentTime > 0.0
  end
  
  def add(resp)
    resp[:add].each do |obj|
      next unless channel = audio_channel_for(obj[:name])
      next if channel_is_playing(channel)
      
      puts "<> Adding channel: #{obj[:name]}"
      channel.volume = obj[:volume][:start]
      channel.pan = obj[:pan][:start]
      audio_controller.addChannels([channel])
      automate obj, channel
    end if resp[:add]
  end

  def remove(resp)
    resp[:remove].each do |name|
      next unless channel = audio_channel_for(name) 
      next unless channel_is_playing(channel)
      
      puts "<> Removing channel: #{name}"
      opts = {direction: "down", start: channel.volume, stop: 0.00, delay: 0.89}
      volume(opts, channel) do |audio|
        audio_controller.removeChannels([audio])
      end
    end if resp[:remove]
  end
  
  def change(resp)
    resp[:change].each do |obj|
      next unless channel = audio_channel_for(obj[:name]) 
      next unless channel_is_playing(channel)
      
      puts "<> Changing channel: #{obj[:name]}"
      automate obj, channel
    end if resp[:change]
  end
  
  def automate(obj, channel)
    volume(obj[:volume], channel) if obj[:volume]
    pan(obj[:pan], channel) if obj[:pan]
  end
  
  def poll_and_realize
    Environment.get(location, playing) do |resp|
      realize(resp)
    end
  end
  
  def cancel_poller
    EM.cancel_timer(poller)
  end
end

