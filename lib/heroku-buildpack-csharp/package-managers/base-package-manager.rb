module HerokuBuildpackCsharp
  module PackageManagers
    class BasePackageManager
      attr_reader :project_parser, :sln_file_path

      def initialize(project_parser, sln_file_path)
        @project_parser = project_parser
        @sln_file_path = sln_file_path
      end

      def update_project_dependencies

      end
    end
  end
end