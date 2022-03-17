#!/bin/bash
echo "---Checking if ioquake3 is installed---"
if [ ! -f ${DATA_DIR}/ioquake3ded ]; then
  echo "---ioquake3 not found, downloading...---"
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/ioquake3.zip "${DL_URL}" ; then
    echo "---Successfully downloaded ioquake3---"
  else
    echo "---Can't download ioquake3 please check your download URL, putting server into sleep mode---"
    sleep infinity
  fi
  echo "---ioquake3 Patch not found, downloading...---"
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/ioquakepatch.zip "${DL_URL_PATCH}" ; then
    echo "---Successfully downloaded ioquake3 Patch---"
  else
    echo "---Can't download ioquake3 Patch please check your download URL, putting server into sleep mode---"
    sleep infinity
  fi
  mkdir -p ${DATA_DIR}/ioquake3ded ${DATA_DIR}/.q3a/baseq3
  unzip -o -d ${DATA_DIR}/ioquake3ded ${DATA_DIR}/ioquake3.zip
  unzip -o -d ${DATA_DIR}/ioquake3ded ${DATA_DIR}/ioquake3ded/*.zip
  unzip -o -d ${DATA_DIR} ${DATA_DIR}/ioquakepatch.zip
  cp -R ${DATA_DIR}/*-pk3s/baseq3/* ${DATA_DIR}/ioquake3ded/baseq3/
  cp -R ${DATA_DIR}/*-pk3s/missionpack/* ${DATA_DIR}/ioquake3ded/missionpack/
  rm -rf ${DATA_DIR}/ioquake3.zip $(ls -f ${DATA_DIR}/ioquake3ded/*.zip 2>/dev/null) ${DATA_DIR}/ioquakepatch.zip $(ls -d ${DATA_DIR}/*-pk3s 2>/dev/null) 2>/dev/null
else
	echo "---ioquake3 found, continuing...---"
fi

echo "---Checking if .pk3 files are present---"
if [ ! -f ${DATA_DIR/.q3a/baseq3/pak0.pk3 ]; then
  echo "-----------------------------------------------------------"
  echo "---No pak file found in your .../.q3a/baseq3/ folder...----"
  echo "----Please paste all your pak*.pk3 files from your game----"
  echo "------directory into your .../.q3a/baseq3/ folder and -----"
  echo "---restart the container, putting server into sleep mode---"
  echo "-----------------------------------------------------------"
  chmod 770 -R ${DATA_DIR}/.q3a
  sleep infinity
else
  echo "---pak0.pk3 found, continuing---"
fi

echo "---Prepare Server---"
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

echo "---Server ready---"
chmod -R ${DATA_PERM} ${DATA_DIR}

sleep infinity

echo "---Starting server---"
cd ${DATA_DIR}
screen -S ioquake3 -L -Logfile ${DATA_DIR}/masterLog.0 -d -m ${DATA_DIR}/ioquake3ded/ioq3ded.x86_64 +set net_ip 0.0.0.0 +set net_port ${IOQ3_PORT} +map ${Q3_MAP} ${GAME_PARAMS}
sleep 2
if [ "${ENABLE_WEBCONSOLE}" == "true" ]; then
  /opt/scripts/start-gotty.sh 2>/dev/null &
fi
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -f ${DATA_DIR}/masterLog.0