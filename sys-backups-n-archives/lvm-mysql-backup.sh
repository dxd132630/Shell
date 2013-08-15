#!/bin/bash
##################################################
# Name: lvm-mysql-backup.sh
# Description: Does a backup of your MySQL Database utilizng LVM Snapshot.
# Script Maintainer: Jacob Amey
#
# Last Updated: August 8th 2013
##################################################
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
##################################################
# Variables
#
user=$LOGNAME
password="password"
datadir="/blah/important/"
tmpmountpoint="/mnt/temp_mount"
dstdir="/blah/backups/mysql_backups/"
##################################################
# Usage Options
#
usage () {
  echo "Usage: $0 [OPTION]"
  echo "-d, --dest=name       Destination directory. Default is /tmp"
  echo "-h, --help            Display this help and exit."
  echo "-p, --password[=name] Password to use when connecting to server. If password is"
  echo "                      not given it's asked from the tty."
  echo "-t                    Temporary mount point for the snapshot. Default is /mnt."
  echo "-u, --user=name       User for login if not current user"
  exit 1
}
##################################################
#Case statemnt.
#
until [ -z "$1" ]; do
  case "$1" in
    -u)
      [ -z "$2" ] && usage
      user="$2"
      shift
      ;;
    --user=*)
      user=`echo $1|cut -f 2 -d '='`
      ;;
    -p*)
      password=`echo $1|sed -e s/"^-p"//g`
      ;;
    --password)
      echo -n "Enter password: "
      stty -echo
      read password
      stty echo
      ;;
    --password=*)
      password=`echo $1|cut -f 2 -d '='`
      ;;
    -d)
      [ -z "$2" ] && usage
      dstdir="$2"
      shift
      ;;
    --dest=*)
      dstdir=`echo $1|cut -f 2 -d '='`
      ;;
    -t)
      [ -z "$2" ] && usage
      tmpmountpoint="$2"
      shift
      ;;
    * )
    usage
    ;;
  esac
  shift
done

[ -z $password ] && echo "Empty password!" && usage
[ ! -d $dstdir ] && echo "$dstdir does not exist" && exit 1
##################################################
# Check if temp mount point not used
#
[ `mount | grep "$tmpmountpoint" | wc -l` -ne 0 ] && exit 1
##################################################
# Get Mysql data directory
#
datadir=`mysql -u $user -p$password -Ns -e "show global variables like 'datadir'"|cut -f 2|sed -e s/"\/$"//g`
[ -z "$datadir" ] && exit 1
##################################################
# Get snap name and size
#
vg=`mount | grep $datadir | cut -d ' ' -f 1 | cut -d '/' -f 4 | cut -d '-' -f 1`
lv=`mount | grep $datadir | cut -d ' ' -f 1 | cut -d '/' -f 4 | cut -d '-' -f 2`
[ -z $lv ] && echo "Mysql data dir must be mounted on a LVM partition!" && exit 1
snap=$lv"snap"
snapsize=$(expr `df -m $datadir | tail -1 | tr -s ' ' | cut -d ' ' -f 2` / 10)M
##################################################
# Backup
#
echo "Locking databases"
mysql -u$user -p$password << EOF
FLUSH TABLES WITH READ LOCK;
system lvcreate --snapshot -n $snap -L$snapsize /dev/$vg/$lv;
UNLOCK TABLES;
quit
EOF
echo "Databases unlocked"
##################################################
##file rotate
#
rm -f $dstdir/mysql.tar.gz.3
mv $dstdir/mysql.tar.gz.2 $dstdir/mysql.tar.gz.3
mv $dstdir/mysql.tar.gz.1 $dstdir/mysql.tar.gz.2
mv $dstdir/mysql.tar.gz $dstdir/mysql.tar.gz.1
##################################################
# Perfrom the backup.
#
echo "Backing up databases"
mount /dev/$vg/$snap $tmpmountpoint
cd $tmpmountpoint
tar cfz $dstdir/mysql.tar.gz *
cd
umount $tmpmountpoint
lvremove -f /dev/$vg/$snap
echo "Databases backed up in $dstdir"

exit 0
##################################################
# EOF
