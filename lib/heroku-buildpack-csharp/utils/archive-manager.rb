module HerokuBuildpackCsharp
  module Utils
    module ArchiveManager

      def self.download_and_extract(url, destination_dir)
        begin
          fetch url, destination_dir

        rescue Exception => e
          puts "Error on step #{e.message}. Aborting."
          raise 'Extract'
        end

      end


      private

      def self.fetch(url, destination)
        print '-----> Fetching mono language pack'
        fetch_output = `mkdir -p #{destination}; cd #{destination}; curl --silent -O #{url}; cd -`
        if not($?.success?)
          puts "\tError"
          puts fetch_output
          raise "'Fetch'"
        end
        puts "\tDone"
        unpack(destination)
      end

      def self.unpack(destination)
        print '-----> Unpacking mono language pack'
        unpack_output = `cd #{destination}; tar -xzf *.tgz; rm -rf *.tgz; cd -`
        if not($?.success?)
          puts "\tError"
          puts unpack_output
          raise "'Unpack'"
        end
        puts "\tDone"
      end
    end
  end
end


