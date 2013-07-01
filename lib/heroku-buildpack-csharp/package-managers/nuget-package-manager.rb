require_relative 'base-package-manager'

module HerokuBuildpackCsharp
  module PackageManagers
    class NugetPackageManager < BasePackageManager

      def initialize(project_parser, sln_file_path, nuget_executable)
        super project_parser, sln_file_path
        @nuget_executable = nuget_executable
      end

      def update_dependencies
        puts @sln_file_path
      end
    end
  end
end