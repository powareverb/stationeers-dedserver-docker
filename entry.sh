#!/bin/bash

TMUXNAME=${STEAMAPP}
TMUXDIRECT=true
#PLANETOID=mars

echo "Running entry.sh"

mkdir -p "${STEAMAPPDIR}" || true  
tmux kill-session -t "${TMUXNAME}"

cd ${STEAMCMDDIR}
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				-beta beta \
				validate \
				+quit

cd ${STEAMAPPDIR}
touch ${STEAMAPPDIR}/keep-running

# Give our app update details
cat ${STEAMAPPDIR}/steamapps/appmanifest_${STEAMAPPID}.acf
head -1 ${STEAMAPPDIR}/rocketstation_DedicatedServer_Data/StreamingAssets/version.ini

# Testing using TMUX to allow interactive session
if [ ${TMUXDIRECT}="true" ]; then
	echo "Running Dedicated Server via tmux"
	tmux new -ds "${TMUXNAME}" "while [ -f ${STEAMAPPDIR}/keep-running ]; do ${STEAMAPPDIR}/rocketstation_DedicatedServer.x86_64 -new ${PLANETOID} -load '${PLANETOID}' ${PLANETOID} -settings ServerName '${SERVERNAME}' StartLocalHost true ServerVisible true ServerPassword '${SERVERPASSWORD}' ServerMaxPlayers 10 GamePort 27500 UpdatePort 27501 UPNPEnabled false AutoSave true SaveInterval 300; sleep 1; done"
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
