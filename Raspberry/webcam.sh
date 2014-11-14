#!/bin/sh
SSHFSOPTS="auto_cache,reconnect,no_readahead,Ciphers=arcfour"
HOST=
RUSER=pi
RDIR=/var/www/html/webcam/images/
LDIR=/home/edu/pics/
OUTPUT=/dev/shm/webcam_tmp.jpg
FINAL=/home/edu/pics/webcam.jpg
HEIGHT=600
WIDTH=800
QUALITY=70
PRESTRING="@minWebcam"

# trap ctrl-c and call ctrl_c()
#trap ctrl_c INT

ctrl_c() {
        echo "** Trapped CTRL-C"
	fusermount -u ${LDIR}
	rm -f ${OUTPUT}
	exit 1
}

#sshfs -o ${SSHFSOPTS} ${RUSER}@${HOST}:${RDIR} ${LDIR}
#sleep 10
#cd ${LDIR}
while true
do
	raspistill -h ${HEIGHT} -w ${WIDTH} -q ${QUALITY} -o ${OUTPUT} -n
	POSTSTRING=$(date)
#	DATE=$(date +%Y%m%d%H%M%S)
#	convert ${OUTPUT} -fill white -undercolor '#00000080' -gravity SouthEast -annotate +0+5 " ${PRESTRING} ${POSTSTRING} " ${FINAL}-${DATE}
	convert ${OUTPUT} -fill white -undercolor '#00000080' -gravity SouthEast -annotate +0+5 " ${PRESTRING} ${POSTSTRING} " ${FINAL}
#	ln -sf ./webcam.jpg-${DATE} ./webcam.jpg
	rm -f ${OUTPUT}
	sleep 20
done
#ctrl_c
