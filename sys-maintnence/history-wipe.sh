#!/bin/bash
##################################################
#
#     !WARNING!	   !WARNING!	!WARNING!
#
# This should only be ran on new systems post build 
# or when cloning a system to be new. Only 
# Reason this exist is to give a system a fresh start
# any other use will be considered malacious.
# 
# To run this scruipt you must:
# 1. chmod +x the script
# 2. source run the script
# 
# example:  source ./history-wipe.sh
#
# dont forget to remove execution when finished!
#
##################################################
# Name: history-wipe.sh
# Description: Cleares out all logs,mail, and cli history.
# Script Maintainer: Jacob Amey
#
# Last Updated: July 31st 2013
##################################################
# Set Base Variables
#
DATE=`date +%m/%d/%Y`
BASELOG="/var/log"
BASESPOOL="/var/spool"
BASEMAIL="/var/spool/mail"
BASESA="/var/log/sa"
ROOT="/root"
MLOG="mail/statistics"
ALOG="audit/audit.log"
##################################################
# Clear out Log and Mail files.
#
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/$ALOG
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/$MLOG
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/boot.log
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/btmp
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/cron
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/dmesg
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/dracut
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/kernel
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/lastlog
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/maillog
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/messages
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/monitorix
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/secure
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/spooler
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/tallylog
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/wtmp
echo "---: New Logs Bellow - $DATE :---" > $BASELOG/yum.log

echo "---: New Logs Bellow - $DATE :---" > $BASESA/sa30
echo "---: New Logs Bellow - $DATE :---" > $BASESA/sa31
echo "---: New Logs Bellow - $DATE :---" > $BASESA/sar30

echo "---: New Logs Bellow - $DATE :---" > $BASEMAIL/root
echo "---: New Logs Bellow - $DATE :---" > $BASEMAIL/monitorix
echo "---: New Logs Bellow - $DATE :---" > $BASEMAIL/rpc
##################################################
# Deletion of data
#
rm -rf $BASELOG/*-*			# Removes all rotated logs that have name-date format.
rm -rf $BASELOG/*.old			# Removes all logs ending in .old.
rm -rf $BASESPOOL/clientmqueue/*	# Empty client Mail Queue.
rm -rf $BASESPOOL/mqueue/*		# Empty Mail Queue.
history -c
rm -rf $ROOT/.bash_history		# Removes history file. (It will recreate its self.)
history -c
##################################################
# EOF
