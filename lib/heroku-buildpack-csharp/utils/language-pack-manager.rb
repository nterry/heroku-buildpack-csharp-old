require 'rubygems'
require 'rubygems/package'
require 'zlib'
require 'fileutils'
require 'open-uri'

require_relative 'archive-manager'

module HerokuBuildpackCsharp
  module Utils

    include ArchiveManager
    class LanguagePackManager

      def initialize(url='http://foo.com/bar/somefile.tgz')
        @url = url
        parse_url
      end

      # "overloaded" constructor to set s3-specific url
      def s3(s3_bucket, mono_version)
        @url = "https://s3.amazonaws.com/#{s3_bucket}/mono3/mono-#{mono_version}.tgz"
        self
      end

      def prepare(temp_dir, slug_dir, build_dir)
        download temp_dir
        #vendor_mono temp_dir, slug_dir
        #vendor_mono temp_dir, build_dir
      end

      private

      def parse_url
        url_sections = @url.scan_url
        @filename = url_sections.last
      end

      def vendor_mono(source_dir, dest_dir)
        FileUtils.cp_r("#{source_dir}/bin", "#{dest_dir}")
        FileUtils.cp_r("#{source_dir}/etc", "#{dest_dir}")
        FileUtils.cp_r("#{source_dir}/include", "#{dest_dir}")
        FileUtils.cp_r("#{source_dir}/lib", "#{dest_dir}")
        FileUtils.cp_r("#{source_dir}/share", "#{dest_dir}")
      end

      def download(dest_dir)
        return if File.exist? "#{dest_dir}/#{@filename}"
        source = open(@url)
        io = ArchiveManager.ungzip source
        ArchiveManager.untar io, dest_dir
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