# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'rubygems'
require 'motion-cocoapods'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'rubygems'
# require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.name = 'Liturgy'
  app.version = "1.0.00"
  # app.short_version = "1.3.0"
  # app.icons = %w( Icon@2x.png Icon.png) 
  app.prerendered_icon = false
  app.device_family = :iphone
  # app.files_dependencies 'app/app_delegate.rb' => 'app/lib/helper.rb'
  app.interface_orientations = [:portrait]
  app.frameworks += %w( CoreAudio )
  app.deployment_target = "7.1"
  app.identifier = 'com.ereth.liturgy'
  app.release do
    app.provisioning_profile = "/Users/deerly/Library/MobileDevice/Provisioning Profiles/2018F2A6-803B-4D19-84BD-F323D1231B69.mobileprovision"
  end
  app.development do
    app.provisioning_profile = "/Users/deerly/Library/MobileDevice/Provisioning Profiles/4C0769D4-6D6A-4753-9225-5E2B740E9D97.mobileprovision"
  end
  
  app.pods do
    pod 'TheAmazingAudioEngine'
  end
  

end