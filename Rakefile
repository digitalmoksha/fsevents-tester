# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'sugarcube-repl'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'fsevents-tester'

  app.pods do
    pod 'CDEvents'
  end
end
