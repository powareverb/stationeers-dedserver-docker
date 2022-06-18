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
# Running using a bind mount for data persistence on container recreation:
mkdir -p $(pwd)/stationeers-data
chmod 777 $(pwd)/stationeers-data # Makes sure the directory is writeable by the unprivileged container user
docker run -d --net=host -v $(pwd)/stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver

# RECOMMENDED: Using a standard named mount for data persistence on container recreation:
docker run -d --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver

# RECOMMENDED: Using docker-compose
docker-compose up -d

```
It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.
The container will automatically update the game on startup, so if there is a game update just restart the container.

## Configuration
### Environment Variables
Feel free to overwrite these environment variables, using -e (--env):

```sh
# TODO: @powareverb Update these to ensure they work
SERVER_PORT=27500 (Game Port (tcp & udp); Steam Query Port (udp) will be SERVER_PORT + 1)
SERVER_PUBLIC=1
SERVER_WORLD_NAME="BraveNewWorld"
SERVER_PW="changeme"
SERVER_NAME="New \"${STEAMAPP}\" Server"
SERVER_LOG_PATH="logs_output/outputlog_server.txt"
SERVER_SAVE_DIR="Worlds"
SCREEN_QUALITY="Fastest"
SCREEN_WIDTH=640
SCREEN_HEIGHT=480
STEAMCMD_UPDATE_ARGS="" (Gets appended here: +app_update [appid] [STEAMCMD_UPDATE_ARGS]; Example: "validate")
ADDITIONAL_ARGS="" (Pass additional arguments to the server. Make sure to escape correctly!)
If you want to learn more about configuring a Valheim server check this documentation.
```

## Image Variants
Only one current variant.

stationeers-dedserver:latest
