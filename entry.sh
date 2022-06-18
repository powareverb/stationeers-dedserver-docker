#!/bin/bash

TMUXNAME=${STEAMAPP}
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

# tmux new -ds "${TMUXNAME}" "while [ -f ${STEAMAPPDIR}/keep-running ]; do ./rocketstation_DedicatedServer.x86_64 -new mars -load 'mars' mars -settings ServerName '${SERVERNAME}' StartLocalHost true ServerVisible true ServerPassword password ServerMaxPlayers 10 GamePort 27500 UpdatePort 27501 UPNPEnabled false AutoSave true SaveInterval 300; sleep 1; done"

tmux new -ds "${TMUXNAME}" && tmux ls

while [ -f ${STEAMAPPDIR}/keep-running ]; do 
  ./rocketstation_DedicatedServer.x86_64 -new ${PLANETOID} -load "${PLANETOID}" ${PLANETOID} -settings ServerName "${SERVERNAME}" StartLocalHost true ServerVisible true ServerPassword "${SERVERPASSWORD}" ServerMaxPlayers 10 GamePort 27500 UpdatePort 27501 UPNPEnabled false AutoSave true SaveInterval 300; 
  sleep 1; 
done

