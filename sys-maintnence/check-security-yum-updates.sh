#!/bin/bash
##################################################
# Name: check-security-yum-updates.sh
# Description: Checks for security ERATA updates, sends an email when there is.
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22nd 2013
##################################################
# Set Variables
#
EMAIL="changeme@email.com"
YUMTMP="/tmp/yum-security-check-update.$$"
YUM="/usr/bin/yum"
$YUM --security check-update >& $YUMTMP
YUMSTATUS="$?"
HOSTNAME=$(/bin/hostname)
#
##################################################
# Main Script
#
case $YUMSTATUS in
0)
# no updates!
exit 0
;;
*)
DATE=$(date)
NUMBERS=$(cat $YUMTMP | egrep '(.i386|.x86_64|.noarch|.src)' | wc -l)
UPDATES=$(cat $YUMTMP | egrep '(.i386|.x86_64|.noarch|.src)')

echo "
There are $NUMBERS updates available on host $HOSTNAME at $DATE

The available updates are:
$UPDATES 
" | /bin/mailx -s "UPDATE: $NUMBERS updates available for $HOSTNAME" $EMAIL
;;
esac
##################################################
# clean up
#
rm -f /tmp/yum-security-check-update.*
# EOF
