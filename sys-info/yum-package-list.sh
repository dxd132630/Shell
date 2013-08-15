#!/bin/bash
##################################################
# Name: yum-package-list.sh
# Description: This script generates the package list then you can pipe this list into yum.
# Script Maintainer: Jacob Amey
#
# Last Updated: July 9th 2013
##################################################
# Simple One Liner
rpm -qa --qf %{NAME}\ > /blah/packages/packageLitst.txt
# EOF
