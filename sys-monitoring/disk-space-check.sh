#!/bin/bash
##################################################
# Name: disk-space-check.sh
# Description: Checks Disk Space, Emails when low
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22th 2013
#
# Common Disk Option Page out Figures
# 1048576 KB  = 1 GB
# 2097152 KB  = 2 GB
# 5242880 KB  = 5 GB
# 10485760 KB = 10 GB
##################################################
#Set Sys Variables
HOSTNAME=`hostname`
IP=`hostname -I`
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

Warning: Disk ${Disk[$i]} has $SPACEG left on


"
# End message Function
##################################################
# Mail Settings
#
MAIL=`which mailx`
MAILTO="user@email.com"
SUBJECT="Warning: low Disk Space for $HOSTNAME"
##################################################
# Devices to Monitor
#
Disk[1]="/dev/sda1"
Disk[2]="/dev/sdb1"
##################################################
# Disk Space Page out point
#
MinDisk[1]=5242880 # 5 GB
MinDisk[2]=5242880 # 5 GB
##################################################
# Main Script
#
for i in `/usr/bin/seq - 1 ${#Disk[@]}`;
do
SPACEK=`/bin/df -k ${Disk[$i]} | /usr/bin/awk '{print $4}' | tail -n 1`
SPACEG=`/bin/df -h ${Disk[$i]} | /usr/bin/awk '{print $4}' | tail -n 1`

if [ $SPACEK -le ${MinDisk[$i]} ];
        then message | $MAIL -s $SUBJECT $MAILTO;
fi
#
done
#EOF
