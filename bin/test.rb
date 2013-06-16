#!/usr/bin/env ruby

require_relative '../lib/heroku/buildpack/csharp/utils/solution_file_manager'

sln_file = '../../CROWBAR/CROWBAR.sln'

sln_file_manager = Heroku::Buildpack::Csharp::SolutionFileManager.new(sln_file)

content = sln_file_manager.parse

puts content