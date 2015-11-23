# ql-docker

A Docker image for running a dedicated Quake Live server.  It includes installation of minqlx and bundles most of the custom maps from the Steam workshop.

## Installation and Usage

To start a new server using this image:

1. Create a directory to store the persistent Redis database files.  For this example I called it ql-redis.
2. Launch a Redis container: `sudo docker run -d --name redis -v ql-redis:/data redis`
3. Launch the Quake Live server container: `sudo docker run -p 27960:27960/udp --link redis -d --name ql -e name="Test Server" -e admin="12345" dpadgett/ql-docker`

This can be automated using Docker's Tutum service, which adds remote log viewing and resource monitoring.  See the included ql-rbx.yml and ql-sjc.yml files for example Tutum stack definitions.

The image exposes a few environment variables to control deployment:

1. `name`: The name of the server
2. `admin`: The steamid of the server admin.  This person will automatically get rcon access to the server when they are connected.
3. `gameport`: The port to start the server on.
4. `rconport`: The port to listen for remote rcon connections from.

To use a custom server configuration, or to add additional files, you can either fork this repository and edit the included files and then build a new image, mount the files into the container using docker's `-v localpath:containerpath` option, or go into the container and edit them manually using `sudo docker exec -t -i containerid /bin/bash`

## Contributing

1. Fork it!
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push`
5. Submit a pull request :D

## License

Apache 2.0
