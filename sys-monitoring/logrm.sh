##################################################
# Name: logrm.sh
# Description: logs removed files to /var/log/messages
# Script Maintainer: Jacob Amey
#
# Last Updated: July 9th 2013
###################################################
# Logs rm command unless -s usage is given.
PWD=`pwd`
#
if [ $# -eq 0 ] ; then
        echo "Usage: $0 [-s] list of files or directories" >&2
        exit 1
fi
#
if [ "$1" = "-s" ] ; then
        #Silent operation requested ... don't log
         shift
else
         logger -p warn -t [DELETED] "${USER} : $PWD : $@"  ||:
fi
#
/bin/rm "$@"
#
exit 0
#EOF
