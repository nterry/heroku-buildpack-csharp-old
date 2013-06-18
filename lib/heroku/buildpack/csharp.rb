require_relative 'csharp/version'
require_relative 'csharp/utils/solution_file_manager'

module Heroku
  module Buildpack
    class Csharp

      def initialize(repo_dir)
        @sln_file_manager = Utils::SolutionFileManager.new(repo_dir)
        @sln_file = @sln_file_manager.parse
      end

      def get_global_property(property_tag, property)
        @sln_file[:global].each do |prop|
          prop_set = prop[:properties] if (prop[:property_tag] === property_tag)
          next if prop_set.nil?
          prop_set.each do |p|
            return p[:value] if p[:key] === property
          end
          raise "Property '#{property}' not found for property tag '#{property_tag}'"
        end
      end

      def get_project_property(project_name, property)
        @sln_file[:projects].each do |project|
          if project[:assembly_info][:name] =~ /("?)#{project_name}("?)/
            return project[:assembly_info][property.to_sym] if (property != 'guid' && project[:assembly_info][property.to_sym])
            return project[:guid] if property === 'guid'
          end
        end
        raise "Property '#{property}' not found for project '#{project_name}'"
      end
    end
  end
end
