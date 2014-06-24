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
  
  # Loads and monitors all audio channels for a :location
  #
  def load_audio_channels_for(location)
    file_names = audio_channels_for(location)
    file_names.each do |name|
      audio = load_audio audio_file_path_for(name, location)
      instance_variable_set(:"@#{name}", audio)
    end
    monitor_audio location
  end
  
  # @return [String] path for audio fie
  def audio_file_path_for(file_name, location)
    File.join('audio', 'clinton_division', file_name) + '.m4a'
  end
  
  # Audio file names for each location.  Uses m4a extension
  def audio_channels_for(location)
    {
      clinton_division: %w( choir )
    }[location]
  end

  def start_audio_controller
    audio_controller.start au_controller_error
    audio_unit_player = AEAudioUnitChannel.alloc.initWithComponentDescription(
      audio_file_player_component, 
      audioController: audio_controller, 
      error: au_player_error
    )
  end
  
  # Automate audio channel's volume or pan. 
  #   :automate_volumne, :automate_pan

  %w( volume pan).each do |kind|
    define_method("automate_#{kind}".to_sym) do |start, finish, step, channel, direction, delay|
      serial_queue = Dispatch::Queue.concurrent("serial_queue_#{rand}")
      serial_queue.async do
        puts "{queue} #{kind} Starting\n"
        range(start, finish, step).each do |float|
          plus_minus = direction == :right || :up ? 1 : -1
          param = ((float + 0.02) * plus_minus).round(2)
          channel.__send__("#{kind}=", param)
          sleep(delay)
        end
      end
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

  # [:au_controller_error, :au_player_error, :au_filter_error]
  #
  # @return Pointer [Object] 
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
        logger visualize_channel(a) 
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

  # @return [Array] of range
  def range(s, f, step=0.01)
    (s..f).step(step).to_a
  end

  def instance(name)
    App.delegate.instance_variable_get(:"@#{name}")
  end
end

#-----------------------------------------------------------------------------
# Loading Audio
#-----------------------------------------------------------------------------

# @audio  = load_audio "audio/loop.m4a"
# @audio2 = load_audio "audio/loop.m4a"
# @audio2.currentTime = 10
# @audio_controller.addChannels [@audio, @audio2]
# @audio_controller.addChannels [audio_unit_player]

# automate_pan 0.00, 0.56, 0.01, @audio, :right, 0.50
# automate_volume 0.01, 0.99, 0.01, @audio, :up, 0.80
# 
# automate_pan -0.99, -0.58, 0.01, @audio2, :left, 0.18
# automate_volume 0.01, 0.68, 0.02, @audio2, :up, 0.80

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
