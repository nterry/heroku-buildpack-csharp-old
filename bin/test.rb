#!/usr/bin/env ruby


require_relative '../lib/heroku/buildpack/csharp'

c = Heroku::Buildpack::Csharp.new('/home/nterry/projects/CROWBAR')

#gprop = c.get_global_property('MonoDevelopProperties', 'StartupItem')
#
#prop = c.get_project_property('CrowbarDaemon', 'guid')
#
#config = XmlSimple.xml_in("/home/nterry/projects/CROWBAR/#{gprop}")
#
#puts gprop
#
#puts prop

puts c.get_executable_path 'Release'
