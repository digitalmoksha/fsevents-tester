# frozen_string_literal: true

$LOAD_PATH.unshift('/Library/RubyMotion/lib')
$LOAD_PATH.unshift('~/.rubymotion/rubymotion-templates')
require 'motion/project/template/osx'

begin
  require 'bundler'
  ARGV.join(' ').include?('spec') ? Bundler.require(:default, :spec) : Bundler.require
rescue LoadError
end

require 'sugarcube-repl'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name                  = 'fsevents-tester'
  app.identifier            = 'com.digitalmoksha.fsevents-tester'
  app.copyright             = "Copyright © 2017 digitalMoksha LLC\nAll Rights Reserved"
  app.short_version         = '0.6' # CFBundleShortVersionString
  app.version               = `git rev-list --all | wc -l`.strip.to_i.to_s  # the build number
  app.sdk_version           = '12.3'
  app.deployment_target     = '10.14'

  app.pods do
    pod 'CDEvents'
  end
end
