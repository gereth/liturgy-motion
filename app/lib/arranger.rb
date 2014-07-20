class Arranger
  include AudioHelper
  attr_accessor :location, :poller

  def initialize(location)
    @location = location
    @poller   = EM.add_periodic_timer(25.0) { poll_and_realize }
  end

  def start
    start_audio_controller
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
      [:add, :remove, :change].each do |op|
        send(op, resp[op]) if resp[op]
      end
    end
  end

  def add(resp)
    resp.each do |obj|
      puts "<> Adding channel: #{obj[:name]}"
      channel = audio_channel(obj[:name], location)
      next if channel_is_playing(channel)

      channel.volume = obj[:volume][:start]
      channel.pan    = obj[:pan][:start]
      audio_controller.addChannels([channel])
      automate obj, channel
    end
  end

  def remove(resp)
    resp.each do |name|
      puts "<> Removing channel: #{name}"
      channel = audio_channel(name, location)
      if channel_is_playing(channel)
        opts = {direction: "down", start: channel.volume, stop: 0.00, delay: 0.89}
        volume(opts, channel) do
          audio_controller.removeChannels([channel])
        end
      end
    end
  end

  def change(resp)
    resp.each do |obj|
      puts "<> Changing channel: #{obj[:name]}"
      channel = audio_channel(obj[:name], location)
      automate(obj, channel) if channel_is_playing(channel)
    end
  end

  def automate(obj, channel)
    puts "<> Starting Automation"
    volume(obj[:volume], channel)
    pan(obj[:pan], channel) if obj[:pan]
  end

  def poll_and_realize
    puts "Loaded channels: %s" % loaded_channel_names.inspect
    Realization.get(location, loaded_channel_names) do |resp|
      realize(resp)
    end
  end

  def cancel_poller
    EM.cancel_timer(poller)
    stop_audio_controller
  end
end
