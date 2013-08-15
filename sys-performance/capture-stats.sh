#!/bin/bash
##################################################
# Name: capture-stats.sh
# Description: Gather System Performance Statistics
# Script Maintainer: Jacob Amey
#
# Last Updated: July 22th 2013
##################################################
# Set  Script Variables
#
REPORT_FILE=/blah/docs/capstats.csv
DATE=`date +%m/%d/%Y`
TIME=`date +%k:%M:%S`
#
##################################################
# Logged in Users
#
USERS=`who | wc -l`
##################################################
# Load Average
#
LOAD=`uptime | cut -d: -f5 | cut -d, -f3`
##################################################
# Memory Free
#
FREE=`free -m | head -n 2 | tail -n 1 | awk {'print $4'}`
##################################################
# Swap Free
#
SWAP=`free -m | tail -n 1 | gawk {'print $3'}`
##################################################
# CPU Idle
#
CPU=`vmstat 1 2 | sed -n '/[0-9]/p' | sed -n '2p' | gawk '{print $15}'`
##################################################
# Disk Space Available
# 
ROOT=`df -h / | awk '{ a = $4 } END { print a }'`
##################################################
# Send Statistics to Report File
#
echo "$DATE,$TIME,$USERS,$LOAD,$FREE MB,$SWAP MB,$CPU %,$ROOT" >> $REPORT_FILE
# EOF
