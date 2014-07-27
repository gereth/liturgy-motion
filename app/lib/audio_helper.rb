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

  def channel_name(channel)
    channel.url.pathComponents.last.split(".").first
  end

  def loaded_channel_names
    audio_controller.channels.map do |c|
      channel_name(c)
    end
  end

  def loaded_audio_channel(name)
    audio_controller.channels.find{ |c| name == channel_name(c)}
  end

  #
  # Return already loaded channel or load audio
  #
  def audio_channel(name, location)
    if loaded_channel_names.include?(name)
      loaded_audio_channel(name)
    else
      load_audio(audio_file_path_for(name, location))
    end
  end

  def channel_is_playing(channel)
    channel.channelIsPlaying && channel.currentTime > 0.0
  end

  def audio_file_path_for(file_name, location)
    File.join('audio', location.to_s, file_name) + '.m4a'
  end

  #
  # Starts AEController unless its running, then removes all channels
  #
  def start_audio_controller
    stop_audio_controller
    audio_controller.start(au_controller_error)
  end

  def stop_audio_controller
    if audio_controller.running
      if audio_controller.channels.any?
        audio_controller.removeChannels(audio_controller.channels)
      end
      audio_controller.stop
    end
  end


  def au_graph
    audio_controller.audioGraph if audio_controller.running
  end

  #
  # Controls the automation of the Channels Volume or Pan: [:volume, :pan ]
  #
  [:volume, :pan].each do |kind|
    define_method(kind) do |opts, channel, &block|
      # serial_queue = Dispatch::Queue.concurrent("serial_queue")
      # serial_queue.async do
      #   range(opts).each do |val|
      #     puts "#{kind} -- #{channel_name(channel)}: #{val}"
      #     channel.__send__("#{kind}=", val)
      #     sleep(opts[:delay])
      #   end
      #   block.call if block
      # end
      opts = {range: opts, channel: channel, kind: kind}
      automation = NSInvocationOperation.alloc.initWithTarget(self, selector: :"automate:", object:  )
      ns_operation_queue.addOperation(automation)
      
    end
  end
  
  def automate(opts)
    range(opts[:range]).each do |val|
      puts "#{opts[:kind]} -- #{channel_name(opts[:channel])}: #{val}"
      channel.__send__("#{opts[:kind]}=", val)
      sleep(opts[:delay])
    end
  end

  def ns_operation_queue
    @ns_operation_queue ||= begin
      NSOperationQueue.new.tap do |queue|
        queue.maxConcurrentOperationCount = 3 
        queue.name = "automation"
      end
    end
  end
    
    

  #
  # Returns a range of floats for volume or pan parameters
  #
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

  #
  # Load audio file resource within resources/audio
  #
  def load_audio(path, opts={})
    audio = AEAudioFilePlayer.audioFilePlayerWithURL(
      path.resource_url,
      audioController: audio_controller,
      error:nil
    )
    unless audio.channelIsPlaying && audio.currentTime > 0.0
      audio.channelIsMuted = false
      audio.currentTime = opts[:start_time] || 0.00
      audio.volume      = opts[:volume] || 0.00
      audio.pan         = opts[:pan] || 0.00
      audio.loop        = opts[:loop] || true
    end
    audio
  end

  %w( au_controller au_player au_filter).each do |name|
    define_method("#{name}_error") do
      Pointer.new(:object)
    end
  end

  # Monitors audio channel and logs pan and volume
  # def monitor_audio(location)
  #   EM.add_periodic_timer 3.0 do
  #     audio_channels_for(location).each do |channel|
  #       a = instance(channel)
  #       visualize_channel(a)
  #     end
  #   end
  # end

  # def visualize_channel(channel)
  #   [:pan, :volume].map do |att|
  #     field = if att == :pan
  #       right = range(0.00, 0.99)
  #       left  = right.reverse.map{ |f| -f }
  #       (left + right)
  #     else
  #       range(0.01,1.00)
  #     end
  #     field.map{|f| f.round(2)}.uniq.map do |f|
  #       if channel.send(att).round(2) == f
  #         f
  #       elsif f == 0.0
  #         "|"
  #       else
  #         "."
  #       end
  #     end.join
  #   end
  # end

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
