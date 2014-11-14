#!/bin/sh
VOICE="es"
FREQ="90.3"
SPEEDMIN=100
SPEEDMAX=150
TYPEMIN=1
TYPEMAX=7
NUMMIN=1
NUMMAX=100
SLEEP=2


SHUF=/usr/bin/shuf
PIFM=/home/edu/gitstuff/pifm/pifm
ESPEAK=/usr/bin/espeak
SUDO=/usr/bin/sudo

while true
do
	SPEED=$(${SHUF} -i ${SPEEDMIN}-${SPEEDMAX} -n1)
	TYPE=$(${SHUF} -i ${TYPEMIN}-${TYPEMAX} -n1)
	MESSAGE=$(${SHUF} -i ${NUMMIN}-${NUMMAX} -n1)

	[ $(${SHUF} -i 0-1 -n1) -eq 1 ] && MF="f" || MF="m"

	${ESPEAK} -v${VOICE}+${MF}${TYPE} -s${SPEED} "${MESSAGE}" --stdout | ${SUDO} ${PIFM} - ${FREQ}
	sleep ${SLEEP}
done
exit 0
