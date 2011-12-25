#!/bin/sh
 
# Microsux.dk
 
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin"
EMAIL="e.minguez@gmail.com"
PORTOUTPUT=""
 
UNAME=`uname -ns`
 
SUBJECT="$UNAME updates available"
echo -e "Good morning,\n\n" > /tmp/dailymail.out
 
portsnap fetch update > /dev/null 2>&1
freebsd-update fetch > /tmp/dailyup.out
 
FUCHECK=`cat /tmp/dailyup.out|tail -1|awk '{ print $1 }'`
 
if [ "$FUCHECK" = "No" ]; then
  PORTOUTPUT=`portversion -vl'<'`
  if [ "$PORTOUTPUT" != "" ]; then
    echo -e "Port updates available:\n" >> /tmp/dailymail.out
    echo $PORTOUTPUT >> /tmp/dailymail.out
    echo "To update ports, use:" >> /tmp/dailymail.out
    echo "# portupgrade -nac" >> /tmp/dailymail.out
    echo "And then:" >> /tmp/dailymail.out
    echo "# portupgrade -ac" >> /tmp/dailymail.out
    echo -e "\n\nEnjoy!\n" >> /tmp/dailymail.out
    mail -s "$SUBJECT" "$EMAIL" < /tmp/dailymail.out
  fi
else
  echo -e "FreeBSD updates fetched and installed:\n\n" >> /tmp/dailymail.out
  cat /tmp/dailyup.out >> /tmp/dailymail.out
  freebsd-update install >> /tmp/dailymail.out
  PORTOUTPUT=`portversion -vl'<'`
  if [ "$PORTOUTPUT" != "" ]; then
    echo -e "\n\nPort updates available:\n" >> /tmp/dailymail.out
    echo $PORTOUTPUT >> /tmp/dailymail.out
    echo "To update ports, use:" >> /tmp/dailymail.out
    echo "# portupgrade -nac" >> /tmp/dailymail.out
    echo "And then:" >> /tmp/dailymail.out
    echo "# portupgrade -ac" >> /tmp/dailymail.out
    echo -e "\n\nEnjoy!\n" >> /tmp/dailymail.out
    mail -s "$SUBJECT" "$EMAIL" < /tmp/dailymail.out
  else
    echo -e "\n\nEnjoy!\n" >> /tmp/dailymail.out
    mail -s "$SUBJECT" "$EMAIL" < /tmp/dailymail.out
  fi
fi
sleep 5
