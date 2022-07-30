###########################################################
# Dockerfile that builds a stationeers Dedicated Gameserver
###########################################################

# Building and Testing
# docker build . -t powareverb/stationeers-dedserver:latest
# docker run --rm -it powareverb/stationeers-dedserver:latest /bin/bash
# docker run --rm powareverb/stationeers-dedserver:latest
# Permanent
# docker run --rm -it --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated-host powareverb/stationeers-dedserver /bin/bash
# docker run -d --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated-host powareverb/stationeers-dedserver

# Jump in 
# docker exec -it stationeers-dedicated bash
# docker exec -it stationeers-dedicated-host bash

# Validate versions - in image
# echo "steam"; cat stationeers-server-dedicated/steamapps/appmanifest_600760.acf | grep buildid
# echo "game"; cat stationeers-server-dedicated/rocketstation_DedicatedServer_Data/StreamingAssets/version.ini | grep UPDATE
# Validate current game version externally
# docker cp 4a2ea3eaa18d:/home/steam/stationeers-server-dedicated/rocketstation_DedicatedServer_Data/StreamingAssets/version.ini ./version.ini
# cat version.ini | grep UPDATE

# https://stationeers-wiki.com/Dedicated_Server_Guide

FROM cm2network/steamcmd:root

LABEL maintainer="gavin.jones.nz@gmail.com"

# Defaults that can be overridden
ENV STEAMAPPID 600760
ENV STEAMAPP stationeers-server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"
ENV VERSION_BRANCH "beta"

COPY ./entry.sh ${HOMEDIR}
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
    # Latest packages due to security warnings
	&& apt-get install -y \
		wget \
		ca-certificates \
		lib32z1 \
		tmux \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/* 

# Switch to user
USER ${USER}
VOLUME ${STEAMAPPDIR}
WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# 27500
# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp

# Required for stationeers server
EXPOSE 27500/udp 27501/udp 
