#!/bin/sh
cd /home/edu/gitstuff/dump1090/
nohup ./dump1090 --net --quiet >/dev/null 2>&1&
