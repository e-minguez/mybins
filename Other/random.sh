#!/bin/sh
SEVERITY_LIST="alert crit debug emerg err info notice warning"
OLDIFS=$IFS
IFS=' '
sev=($SEVERITY_LIST)
num_sev=${#sev[*]}
IFS=$OLDIFS
while true
do
	RAND=$RANDOM
	SEVERITY=${sev[$((RAND%num_sev))]}
	#logger -p user.$SEVERITY $RAND
	echo $RAND - $SEVERITY
	sleep $(( RAND %= 15 ))
done
