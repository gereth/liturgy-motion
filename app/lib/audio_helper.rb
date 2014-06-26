
module AudioHelper

  def audio_controller
    @audio_controller ||= begin
      AEAudioController.alloc.initWithAudioDescription(
        AEAudioController.nonInterleaved16BitStereoAudioDescription
      )
    end
  end
  
  def audio_file_player_component
    AEAudioComponentDescriptionMake(
      KAudioUnitManufacturer_Apple, 
      KAudioUnitType_Generator, 
      KAudioUnitSubType_AudioFilePlayer
    )
  end
  
  # Loads all the channels for a location.
  def load_audio_channels_for(location)
    file_names = audio_channels_for(location)
    file_names.map do |name|
      {
        name: name,
        channel: load_audio(audio_file_path_for(name, location))
      }
    end
  end
  
  # String file_path for audio
  def audio_file_path_for(file_name, location)
    File.join('audio', 'clinton_division', file_name) + '.m4a'
  end
  
  # Audio file names for each location
  def audio_channels_for(location)
    {
      clinton_division: %w( choir )
    }.fetch(location)
  end

  def start_audio_controller
    audio_controller.start au_controller_error
    audio_unit_player = AEAudioUnitChannel.alloc.initWithComponentDescription(
      audio_file_player_component, 
      audioController: audio_controller, 
      error: au_player_error
    )
  end
  
  def au_graph
    audio_controller.audioGraph if audio_controller.running
  end
  
  # Ride the channel's volume or pan. 
  [:volume, :pan].each do |kind|
    define_method(kind) do |opts, channel, delay, &block|
      serial_queue = Dispatch::Queue.concurrent("serial_queue_#{rand}")
      serial_queue.async do
        range(opts).each do |val|
          puts val
          channel.__send__("#{kind}=", val)
          sleep(delay)
        end
        block.call(channel)
      end
    end
  end

  # Returns a range of floats for volume or pan parameters
  def range(opts)
    step     = opts[:step] || 0.08
    variance = opts[:variance] || 0.02
    start    = opts[:start] || 0.50
    stop     = opts[:stop] || 1.0
    
    floats = if opts[:direction] == "down"
      (stop..start)
    else
      (start..stop)
    end.step(step).to_a
    floats.reverse! if opts[:direction] == "down"
    
    power = opts[:direction] =~ /up|down|right/ ? 1 : -1
    floats.map do |float|
      ((float + variance) * power).round(2)
    end
  end
    
  # Load audio file resource within resources/audio
  #
  # @return [Object]
  def load_audio(path, opts={})
    audio = AEAudioFilePlayer.audioFilePlayerWithURL(
      path.resource_url, 
      audioController: audio_controller, 
      error:nil
    )
    audio.channelIsMuted = false
    audio.currentTime = opts[:start_time] || 0.00
    audio.volume      = opts[:volume] || 1.0
    audio.pan         = opts[:pan] || 0.00
    audio.loop        = opts[:loop] || true
    audio
  end

  %w( au_controller au_player au_filter).each do |name|
    define_method("#{name}_error") do
      Pointer.new(:object)
    end
  end
  
  # Monitors audio channel and logs pan and volume
  def monitor_audio(location)
    EM.add_periodic_timer 3.0 do
      audio_channels_for(location).each do |channel|
        a = instance(channel)
        visualize_channel(a) 
      end
    end
  end

  def visualize_channel(channel)
    [:pan, :volume].map do |att|
      field = if att == :pan
        right = range(0.00, 0.99)
        left  = right.reverse.map{ |f| -f }
        (left + right)
      else
        range(0.01,1.00)
      end
      field.map{|f| f.round(2)}.uniq.map do |f|
        if channel.send(att).round(2) == f
          f
        elsif f == 0.0
          "|"
        else
          "."
        end
      end.join
    end
  end

  def instance(name)
    instance_variable_get(:"@#{name}")
  end
end


#-----------------------------------------------------------------------------
# Limiter & Filters
#-----------------------------------------------------------------------------

# @limiter = AELimiterFilter.alloc.initWithAudioController(@audio_controller)
# @limiter.level  = 10.0
# @limiter.hold   = 100.0
# @limiter.attack = 0.01

# delay_component = AEAudioComponentDescriptionMake(
#   KAudioUnitManufacturer_Apple, 
#   KAudioUnitType_Effect,
#   KAudioUnitSubType_Delay
# )
# @ae_filter = AEAudioUnitFilter.alloc.initWithComponentDescription(delay_component, audioController:@audio_controller, error: au_filter_error)
