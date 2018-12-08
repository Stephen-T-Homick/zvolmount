#!/bin/bash

# Mounts zvols on boot

set -eu

pool="loftPool"
loftpoolimport=$(zpool import | wc -l)
shomenas="/dev/zvol/loftPool/home/shomeNAS-part1"
timemachine="/dev/zvol/loftPool/home/timemachine-part1"
#iso="/dev/zvol/loftPool/home/iso-part1"

if [ $loftpoolimport -gt 0 ] ; then # If the wc of zpool import is greater than 1, pool is likely not imported.
	logger "$0 $pool not imported. Check to make sure drives are inserted and canmount property is set to 'on' "
	$(command -v zpool) import $pool #Imports pool
else
	logger "$0 loftPool already imported. Mounting zvols"

fi # if [ $loftpoolimport -gt 0 ] ; then

if [ -b $shomenas ] && [ -b $timemachine ] ; then # If shomenas zvol / block device exists.
	(mount $shomenas /mnt/shomeNAS) && logger "shomeNAS zvol mounted successfully" || logger "trouble mounting zvols" # Mounts them 
both successfully
	mount $timemachine /mnt/timemachine && logger "timemachine zvol mounted successfully" || logger "trouble mounting timemachine 
zvol $timemachine"
	if [ $? -ne 0 ] ; then # If exit status is anything less than successful (0)
		logger "$0 assetremount - trouble mounting zvols. Check to make sure pool(s) are imported."
	fi #if [ $? -ne 0 ]
else
	logger "$0 Trouble mounting zvols. Check to make sure pool(s) are imported, and drive(s) are properly inserted."
fi #if [ -b $shomenas ] && [ -b $iso ]; then
