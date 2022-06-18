###########################################################
# Dockerfile that builds a stationeers Dedicated Gameserver
###########################################################

# docker build . -t powareverb/stationeers-dedserver:latest
# docker run --rm -it powareverb/stationeers-dedserver:latest /bin/bash
# docker run --rm powareverb/stationeers-dedserver:latest
# Permanent
# docker run --rm -it --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver /bin/bash
# docker run -d --net=host -v stationeers-data:/home/steam/stationeers-server-dedicated/ --name=stationeers-dedicated powareverb/stationeers-dedserver

# Jump in 
# docker exec -it stationeers-dedicated bash

# https://stationeers-wiki.com/Dedicated_Server_Guide

FROM cm2network/steamcmd:root

LABEL maintainer="gavin.jones.nz@gmail.com"

ENV STEAMAPPID 600760
ENV STEAMAPP stationeers-server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

COPY ./entry.sh ${HOMEDIR}
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		lib32z1=1:1.2.11.dfsg-2+deb11u1 \
		tmux \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Add entry script
	# && wget --max-redirect=30 "${DLURL}/master/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
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

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# 27500
# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp

# Required for stationeers server
EXPOSE 27500/udp 27501/udp 
