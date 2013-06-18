#!/usr/bin/env ruby

require_relative '../lib/heroku/buildpack/csharp'

#sln_file = '../../CROWBAR/CROWBAR.sln'

#sln_file_manager = Heroku::Buildpack::Csharp::SolutionFileManager.new(sln_file)

#content = sln_file_manager.parse

#puts content

c = Heroku::Buildpack::Csharp.new('/home/nterry/projects/CROWBAR/CROWBAR.sln')

gprop = c.get_global_property('MonoDevelopProperties', 'StartupItem')

prop = c.get_project_property('CrowbarDaemon', 'guid')

#puts gprop

#puts prop

