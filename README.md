<<<<<<< HEAD
# Heroku::Buildpack::Csharp

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'heroku-buildpack-csharp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku-buildpack-csharp

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
Heroku buildpack: Mono
======================

Building Mono 2.10.8 via Vulcan
-------------------------------
1) Download mono tarball and extract into buildpack-mono/mono-2.10.8

    http://www.mono-project.com/Compiling_Mono_From_Tarball

2) Tar archive source

    cd mono-2.10.8 && tar czvf mono-src.tgz .

3) Build Mono via Vulcan. 
One approach is to provide the archive, this is useful while debugging failed builds. 

    vulcan build -s mono-src.tgz -p /tmp/mono210 -c "./autogen.sh --with-moonlight=no --enable-nls=no --prefix=/tmp/mono210 && ./configure --with-moonlight=no --enable-nls=no --prefix=/tmp/mono210 && make && make install"
Alternatively, package and upload in one step.

    vulcan build -s ./mono-2.10.8 -p /tmp/mono210 -c "./autogen.sh --with-moonlight=no --enable-nls=no --prefix=/tmp/mono210 && ./configure --with-moonlight=no --enable-nls=no --prefix=/tmp/mono210 && make && make install"

4) This will throw a 503 error, however the build is added to the database. As such, need to rebuild with the correct ID.

5) Issue rebuild command for the previously uploaded build. At this point you should see the output stream of the build process.

Once the build has been completed successfully it will be downloaded and saved onto your local machine. 

Upload built Mono binaries to S3
--------------------------------
Within the bin/compile script, it downloads the previously built Mono binaries onto the Heroku dyno. As such, the binaries need to be uploaded onto S3.

Using BuildPack
---------------
In order to take advantage of Mono and Heroku, you need to specify the buildpack when you create your application.

    $ heroku create --stack cedar --buildpack http://github.com/BenHall/heroku-buildpack-mono
    
When you push your source code, the buildpack will be downloaded and execute - that's when the magic happens.
>>>>>>> 6868eb3a3c04f71716f021809052212c8f54cfc3
