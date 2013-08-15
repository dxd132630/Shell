#!/bin/bash
#
# capture-stats.sh - Gather System Performance Statistics
##################################################################
# Set  Script Variables
#
REPORT_FILE=/blah/docs/capstats.csv
DATE=`date +%m/%d/%Y`
TIME=`date +%l:%M%p`
#
##################################################################
# Logged in Users
#
USERS=`who | wc -l`
##################################################################
# Load Average
#
LOAD=`uptime | cut -d: -f5 | cut -d, -f3`
##################################################################
# Memory Free
#
FREE=`free -m | head -n 2 | tail -n 1 | awk {'print $4'}`
##################################################################
# Swap Free
#
SWAP=`free -m | tail -n 1 | awk {'print $3'}`
##################################################################
# CPU Idle
#
CPU=`vmstat 1 2 | sed -n '/[0-9]/p' | sed -n '2p' | gawk '{print $15}'`
##################################################################
# Disk Space Available
# 
ROOT=`df -h / | awk '{ a = $4 } END { print a }'`
VAR=`df -h /var | awk '{ a = $4 } END { print a }'`
USR=`df -h /usr | awk '{ a = $4 } END { print a }'`
###########################################################
# Send Statistics to Report File
#
echo "$DATE,$TIME,$USERS,$LOAD,$FREE MB,$SWAP MB,$CPU %,$ROOT,$VAR,$USR" >> $REPORT_FILE
# EOF

