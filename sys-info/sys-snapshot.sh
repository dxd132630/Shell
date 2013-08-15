#!/bin/bash
##################################################
# Name: sys-snapshot.sh
# Description: produces a report for system stats
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22th 2013
##################################################
# Set Script Variables
#
DATE=`date +%m%d%Y`
DISKS_TO_MONITOR="/dev/sda1"
MAIL=`which mutt`
MAIL_TO=user
REPORT=/home/user/Documents/Snapshot_Stats_$DATE.rpt
####################################################
# Create Report File
#
exec 3>&1 # Save file descriptor
#
exec 1> $REPORT # direct output to rpt file.
#
####################################################
#
echo
echo -e "\t\tDaily System Report"
echo
#
####################################################
#Date Stamp the Report
#
echo -e "Today is `date +%m/%d/%Y`"
echo
#
####################################################
# 1) Gather System Uptime Statistics
#
echo -e "System has been \c"
uptime | sed -n '/,/s/,/ /gp' | gawk '{if ($4 == "days" || $4 == "days") 
	{print $2,$3,$4,$5} 
	       else {print $2,$3}}'
#
####################################################
# 2) Gather Disk Usage Statistics
#
echo
for DISK in $DISKS_TO_MONITOR	#loop to check disk space
do
	echo -e "$DISK usage: \c"
	df -h $DISK | sed -n '/% \//p' | gawk '{print $5}'
done
#
#####################################################
# 3) Gather Memory Usage Statistics
#
echo
echo -e "Memory Usage: \c"
#
free | sed -n '2p' | gawk 'x = int(($3 / $2) *100) {print x}' | sed 's/$/%/'
#
#####################################################
# 4) Gather Number of Zombie Processes
#
echo
ZOMBIE_CHECK=`ps -al | gawk '{print $2,$4}' | grep Z`
#
if [ $ZOMBIE_CHECK = ""]
then
	echo "No Zombie Process on System at this time"
else
	echo "Current System Zombie Processes" ps -al | gawk '{print $2,$4}' |grep Z
fi
echo
#
######################################################
# Restore file descriptor and Mail report
#
exec 1>&3	#Restore output to STDOUT
#
$MAIL -a $REPORT -s "System Statistics Report for $DATE" -- $MAIL_TO < /dev/null
#
######################################################
# Clean up
#
rm -f $REPORT
#
# EOF
