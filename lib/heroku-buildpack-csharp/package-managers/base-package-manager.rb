module HerokuBuildpackCsharp
  module PackageManagers
    class BasePackageManager
      attr_reader :project_path

      def initialize(project_path)
        @project_path = project_path
      end

      def update_project_dependencies

      end
    end
  end
end