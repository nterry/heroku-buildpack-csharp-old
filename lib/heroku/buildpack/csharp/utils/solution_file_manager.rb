module Heroku
  module Buildpack
    module Csharp
      class SolutionFileManager
        attr_reader :solution_file

        def initialize(solution_file_path='')
          @solution = {}
          if not File.exist?(solution_file_path)
            raise "Could not find solution at #{solution_file_path} or in the project root." if not File.exist?(/^.*\.sln/)
            @solution_file = File.open(/^.*\.sln/, 'r+')
          else
            @solution_file = File.open(solution_file_path, 'r+')
          end
        end

        def parse
          @solution[:projects] = []
          @solution[:global] = []
          run_parse(@solution_file.read)
          @solution
        end


        private

        def run_parse(sln_contents)
          version_info = sln_contents.scan(/^(.*)Solution\sFile,\sFormat\sVersion\s(\d+\.\d+)/)
          @solution[:version_info] = { :sln_type => version_info[0][0].strip, :sln_version => version_info[0][1].strip }
          projects = sln_contents.scan(/(^Project.*)/)
          projects.each do |project|
            @solution[:projects] << parse_project(project[0])
          end
          global_sections = sln_contents.scan(/(GlobalSection.*?EndGlobalSection)/m)
          global_sections.each do |global_section|
            @solution[:global] << parse_global_section(global_section)
          end
        end

        def parse_project(project)
          first_split = project.split('=').each { |x| x.strip }
          guid = first_split[0].scan(/.*(\"\{.*\}\").*/)[0][0]
          pre_value = first_split[1].split(',').each { |x| x.strip }
          value = {:name => pre_value[0].strip, :path => pre_value[1].strip, :guid => pre_value[2].strip }
          return { :guid => guid.strip,  :assembly_info => value }
        end

        def parse_global_section(global_section)
          global_hash = {}
          global_hash[:properies] = []
          tmp = global_section.first.scan(/^GlobalSection\((.*?)\)\s=\s(preSolution|postSolution)(.*)(EndGlobalSection)/m)
          global_hash[:property_tag] = tmp[0][0]
          global_hash[:property_step] = tmp[0][1]
          tmp[0][2].gsub("\t", '').strip.split("\n").each do |property|
            kv_prop = property.split('=')
            global_hash[:properies] << { :key => kv_prop[0].strip, :value => kv_prop[1].strip }
          end
          global_hash
        end
      end
    end
  end
end
