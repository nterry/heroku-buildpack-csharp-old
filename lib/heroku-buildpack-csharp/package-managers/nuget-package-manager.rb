require_relative 'base-package-manager'

require 'iron-spect'

module HerokuBuildpackCsharp
  module PackageManagers
    class NugetPackageManager < BasePackageManager

      def initialize(project_path, nuget_executable)
        super project_path
        @nuget_executable = nuget_executable
        @sln_parser = IronSpect::Parsers::SolutionFileParser.new(project_path)
        update_nuget
      end

      def update_dependencies(dependencies_dir='packages')
        Dir.chdir @project_path
        projects = get_projects
        projects.each do |project|
          packages_config = "#{project[:assembly_info][:name]}/packages.config"
          `#{@nuget_executable} install #{packages_config} -o #{dependencies_dir}`
        end
      end


      private

      def get_projects
        @sln_parser.parse[:projects]
      end

      def update_nuget
        `#{@nuget_executable} update -self`
        raise 'Failed to update NuGet.' if not($?.success?)
      end
    end
  end
end