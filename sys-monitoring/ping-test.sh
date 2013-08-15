#!/bin/bash
##################################################
# Name: ping-test.sh
# Description: pings specified host(s) and sends an email when ping resolves to zero.
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22th 2013
##################################################
# Set Variables
#
HOSTS=" "     							# DNS or IP of host(s) to be checked.                                
COUNT="4"                                               	# Number of ping request.
SUBJECT="Ping failed - Server(s) may be down"           	# Subject Head of Email.
EMAILID="user@email.com"                        	        # Email address of Users to receive Notification.
##################################################
# check pingability, send email if not.
#
for myHost in $HOSTS
do
        count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
        if [ $count -eq 0 ]; then
                echo "Host : $myHost is not responding (ping failed) at $(date)" | mailx -s "$SUBJECT" $EMAILID
        fi  
done
#
#EOF
