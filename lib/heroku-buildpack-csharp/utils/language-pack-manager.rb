require 'rubygems'

require_relative 'archive-manager'

module HerokuBuildpackCsharp
  module Utils
    class LanguagePackManager
      include ArchiveManager

      def initialize(url='http://foo.com/bar/somefile.tgz')
        @url = url
        parse_url
        self
      end

      # "overloaded" constructor to set s3-specific url
      def s3(s3_bucket, artifact_path)
        @url = "https://s3.amazonaws.com/#{s3_bucket}/#{artifact_path}"
        parse_url
        self
      end

      def prepare(temp_dir, slug_dir, build_dir)
        begin
          download temp_dir
          download_nuget 'https://az320820.vo.msecnd.net/downloads/nuget.exe', "#{build_dir}/bin"
          vendor_mono temp_dir, slug_dir
          vendor_mono temp_dir, build_dir
        rescue Exception => e
          puts "Failed to prepare buildpack. Failed on step '#{e.message}'"
          raise 'Prepare'
        end
      end


      private

      def parse_url
        url_sections = @url.scan_url
        @filename = url_sections.last
      end

      def vendor_mono(source_dir, dest_dir)
        print "-----> Vendoring mono into #{dest_dir}"
        vendor_result = `mkdir -p #{dest_dir}; cp -r #{source_dir}/* #{dest_dir}`
        if not($?.success?)
          puts "\tError"
          puts vendor_result
          raise "'vendor_#{dest_dir}'"
        end
        puts "\tDone"
      end

      def download(dest_dir)
        return if File.exist? "#{dest_dir}/#{@filename}"
        ArchiveManager.download_and_extract @url, dest_dir
      end

      def download_nuget(url, dest_dir)
        print '-----> Fetching Nuget'
        nuget_download_result = `mkdir -p #{dest_dir}; cd #{dest_dir}; curl --silent -O #{url}; chmod 755 nuget.exe; cd -`
        if not($?.success?)
          puts "\tError"
          puts nuget_download_result
          raise 'download_nuget'
        end
        puts "\tDone"
      end
    end
  end
end

class String
  def scan_url
    raise 'Malformed url' if not(self =~ /(https?:\/\/)(.*?\..+?\/)((.*\/)(.*\..*))?/)
    self.scan(/(https?:\/\/)(.*?\..+?\/)((.*\/)(.*\..*))?/)[0]
  end
end