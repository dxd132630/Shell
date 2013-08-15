#!/bin/bash
##################################################
# Name: port-check.sh
# Description: Checks specified port(s),can restart service(s)
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22th 2013
##################################################
# Set Variables
#
IP=`hostname -I`
HOSTNAME=`hostname`
##################################################
# Modifiable Variables
#
SERVICE="httpd"
PORT="80"
HOST="127.0.0.1"
##################################################
# Mail Settings
#
MAIL=`which mailx`
MAILTO="user@email.com"
##################################################
# Logging Settings
#
LOG_FILE="/var/log/port-check.log"
##################################################
# Message Function
#
function message {
echo "
------------: Sys Info :---------------
              
Hostname : $HOSTNAME 
IP : $IP
Date-Time : `date`

---------------------------------------                

Port $PORT is not responding. 

Restarting the $SERVICE service.
"
}
# End message Function
##################################################
# Check Port, Do nothing or restart and report.
#
nc -z $HOST $PORT;

if [ $? != 0 ]; then #I am down restarting and telling you about it.
	message | $MAIL -s "$SERVICE is not responding on $HOSTNAME" "$MAILTO"
	service $SERVICE restart
	touch $LOG_FILE
	message >> $LOG_FILE
else # Im fine doing nothing.
	echo "port $PORT on server $HOSTNAME is up at $(date)" >> /dev/null
fi
# EOF
