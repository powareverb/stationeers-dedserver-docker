#!/bin/bash

TMUXNAME=${STEAMAPP}
TMUXDIRECT=true

echo "Running entry.sh"

mkdir -p "${STEAMAPPDIR}" || true  
tmux kill-session -t "${TMUXNAME}"

# Check for our prebake dir, and pre-populate the app if we have it
if [ -f ${PREBAKEDIR}/rocketstation_DedicatedServer.x86_64 ]; then
	echo "Copying prebaked install files to main steamapp dir - THIS WILL OVERWRITE YOUR FILES!"
	mkdir -p ${STEAMAPPDIR}
	cp -Rf ${PREBAKEDIR}/. ${STEAMAPPDIR}
fi

cd ${STEAMCMDDIR}
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				-beta beta \
				validate \
				+quit

# When building our prebake, we use this flag to install and quit
if [ ${PREBAKE}="true" ]; then
	echo "Prebake complete, exiting"
	exit
fi

cd ${STEAMAPPDIR}
touch ${STEAMAPPDIR}/keep-running

# Give our app update details
echo "steam"; cat ${STEAMAPPDIR}/steamapps/appmanifest_${STEAMAPPID}.acf | grep buildid
echo "game"; cat ${STEAMAPPDIR}/rocketstation_DedicatedServer_Data/StreamingAssets/version.ini | grep UPDATE

# Testing using TMUX to allow interactive session
if [ ${TMUXDIRECT}="true" ]; then
	echo "Running Dedicated Server via tmux"
	tmux new -ds "${TMUXNAME}" "while [ -f ${STEAMAPPDIR}/keep-running ]; do ${STEAMAPPDIR}/rocketstation_DedicatedServer.x86_64 -new ${PLANETOID} -load '${SAVENAME}' ${PLANETOID} -settings ServerName '${SERVERNAME}' StartLocalHost true ServerVisible true ServerPassword '${SERVERPASSWORD}' ServerMaxPlayers 10 GamePort 27500 UpdatePort 27501 UPNPEnabled false AutoSave true SaveInterval 300; sleep 1; done"
	tmux pipe-pane -t "${TMUXNAME}" 'cat >/tmp/rocketstation_DedicatedServer.log'
	sleep 5
	tail -f /tmp/rocketstation_DedicatedServer.log
else

	# This just runs the session normally
	while [ -f ${STEAMAPPDIR}/keep-running ]; do 
		if [ ${DONOOP}="true" ]; then
			echo "noop"
			sleep 60; 
		else
			echo "Running Dedicated Server"
			./rocketstation_DedicatedServer.x86_64 -new ${PLANETOID} -load "${PLANETOID}" ${PLANETOID} -settings ServerName "${SERVERNAME}" StartLocalHost true ServerVisible true ServerPassword "${SERVERPASSWORD}" ServerMaxPlayers 10 GamePort 27500 UpdatePort 27501 UPNPEnabled false AutoSave true SaveInterval 300; 
			sleep 1; 
		fi
	done
fi
