#!/bin/bash

# This script will mount specified zvols on boot.
# Set this in crontab as '@reboot' notation to start on boot.

set -o pipefail   # If a command anywhere in the set of piped commands failed, the whole line should fail
set -u  # Uninitialized variables should cause an error
set -e # Exit the script if any command fails

# Adjust zvol1 and zvol2 / pool as needed for your own storage pool(s) / zvol mounting naming conventions.

iso="/dev/zvol/loftPool/home/iso-part1" #zvol1
poolimport=`zpool import | wc -l`
pool="loftPool"
shomenas="/dev/zvol/loftPool/home/shomeNAS-part1" #zvol2

if [ $poolimport -gt 0 ] ; then # If the wc value of zpool import is greater than 1, pool is likely not imported.
	logger "$pool not imported. Check to make sure drives are inserted and canmount property is set to 'on' " # Appropriate syslog'ging
	$(command -v zpool) import $pool #Imports pool
else
	logger "loftPool already imported. Mounting zvols"

fi # if [ $loftpoolimport -gt 0 ] ; then

if [ -b $shomenas ] && [ -b $iso ]; then # If both block devices exist.
	(mount $shomenas /mnt/shomeNAS ; mount $iso /mnt/iso) && logger "shomeNAS and iso zvols mounted successfully" || logger "trouble mounting zvols" # Mounts them both successfully
	if [ $? -ne 0 ] ; then # If exit status is anything less than successful (0)
		logger "$0 assetremount - trouble mounting zvols. Check to make sure pool(s) are imported."
	fi #if [ $? -ne 0 ]
else
	logger "$0 Trouble mounting zvols. Check to make sure pool(s) are imported, and drive(s) are properly inserted."
fi #if [ -b $shomenas ] && [ -b $iso ]; then
