#!/bin/bash

# Mounts zvols on boot

set -eu

pool="loftPool"
loftpoolimport=`zpool import | wc -l` 
shomenas="/dev/zvol/loftPool/home/shomeNAS-part1"
iso="/dev/zvol/loftPool/home/iso-part1"

if [ $loftpoolimport -gt 0 ] ; then # If the wc of zpool import is greater than 1, pool is likely not imported.
	logger "$pool not imported. Check to make sure drives are inserted and canmount property is set to 'on' "
	$(command -v zpool) import $pool #Imports pool
else
	logger "loftPool already imported. Mounting zvols"

fi # if [ $loftpoolimport -gt 0 ] ; then

if [ -b $shomenas ] && [ -b $iso ]; then # If both block devices exist.
	(mount $shomenas /mnt/shomeNAS ; mount $iso /mnt/iso) && logger "shomeNAS and iso zvols mounted successfully" || logger "trouble mounting zvols" # Mounts them both successfully
	if [ $? -ne 0 ] ; then # If exit status is anything less than successful (0) 
		logger "assetremount - trouble mounting zvols. Check to make sure pool(s) are imported."
	fi #if [ $? -ne 0 ]
else
	logger "Trouble mounting zvols. Check to make sure pool(s) are imported, and drive(s) are properly inserted."
fi #if [ -b $shomenas ] && [ -b $iso ]; then

