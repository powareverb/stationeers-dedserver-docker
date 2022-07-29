# Overview

Based on the amazing work from
https://hub.docker.com/r/cm2network/steamcmd

And discovery work from the Discord community

Check out the guide here, and note the minimum specifications for running this server.
- https://stationeers-wiki.com/Dedicated_Server_Guide

In particular - the server currently requires 16GM RAM

## Status

NOTE: This is a work in progress, currently running but haven't confirmed getting networking / clients connected
As of:
"LastUpdated"           "1655527706"
"buildid"               "8961321"
Update 0.2.3346.16562
this seems to be running correctly, however having issues with timeouts connecting to the client.

## What is Stationeers?
A brutal exploration and survival game in space, set on a procedurally-generated planet or moon of your choice.  Don't forget your duct tape.

insert logo here

## How to use this image
Hosting a simple game server
Running on the host interface (recommended):

```sh
# RECOMMENDED: Using docker-compose
docker-compose up -d

# NOTE: Neither net-host option will work in Windows, due to networking incompatibilities.  Use the docker-compose version.
# RECOMMENDED: Using a standard named mount for data persistence on container recreation:
docker run -d --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver

# Running using a bind mount for data persistence on container recreation:
mkdir -p $(pwd)/stationeers-data
chmod 777 $(pwd)/stationeers-data # Makes sure the directory is writeable by the unprivileged container user
docker run -d --net=host -v $(pwd)/stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver

```
It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.
The container will automatically update the game on startup, so if there is a game update just restart the container.

## Configuration
### Environment Variables
Feel free to overwrite these environment variables, using -e (--env):

```sh
# These are the current defaults in the compose, but you can (and should!) override them

# Timezone - not sure this is needed
TZ: 'Pacific/Auckland'

# Server name which will be announced to the master server
SERVERNAME: "powareverb-stationeers-dedserver-test"

# Password to stop all those undesirable stationeers from joining
SERVERPASSWORD: "supersafepassword"

# Start planetoid to use
PLANETOID: "mars"

# Name of the save game to load - will be created if it doesn't exist
SAVENAME: "mars101"

# Enable tmux for the console, highly recommended
TMUXDIRECT: "true"
```

## Image Variants

### Auto updating variant

This is an image which will auto update on startup, and may take a while to download the necessary images.  
Once files are downloaded, the startup time is quite quick.

- stationeers-dedserver:latest

### Pre-baked auto updating variant

This is an image which includes the latest version of the server as at time of build.  It will be a much larger image.
The image will still auto update on startup, and may take a while to download the necessary images if there's a new server version.
Once files are downloaded, the startup time is quite quick.

- stationeers-dedserver:prebaked-latest
