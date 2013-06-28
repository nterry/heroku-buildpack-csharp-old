module HerokuBuildpackCsharp
  module Utils
    module ArchiveManager

      def self.ungzip(tarfile)
        z = Zlib::GzipReader.new(tarfile)
        unzipped = StringIO.new(z.read)
        z.close
        unzipped
      end

      def self.untar(io, destination)
        Gem::Package::TarReader.new io do |tar|
          tar.each do |tarfile|
            destination_file = File.join destination, tarfile.full_name
            if tarfile.directory?
              FileUtils.mkdir_p destination_file
            else
              destination_directory = File.dirname(destination_file)
              FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
              File.open destination_file, 'wb' do |f|
                f.print tarfile.read
              end
            end
          end
        end
      end
    end
  end
end


