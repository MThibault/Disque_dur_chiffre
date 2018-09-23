#!/usr/bin/env bash

#########################################################
#	Script to mount the encrypted partition		#
#########################################################

#Author : Thibault MILLANT

## CHANGELOG :
## - Storage partition support added
## - Translating the code from french to english
## - Changing the code with Nextcloud instead of Owncloud

#########################
#	Function	#
#########################
function choose_mount() {
	echo "1 - Mount the partition for Owncloud/Nextcloud"
	echo "2 - Mount a storage partition"
	echo "3 - Manual mounting"
	read -p "Select the number corresponding to your solution you want to use : " chosen_mount
	echo ""
}


## Start Script
echo "At least, you need to send to the script, as first parameter, the partition you want to set up (example : /dev/sdb1)."
if [ -z "$1" ]; then # Partition to use
	echo "You forgot to enter the parameter related to the partition when you called the script (first parameter)."
	exit 1
fi
echo ""

choose_mount
case "$chosen_mount" in
1) 
	cryptsetup luksOpen $1 Nextcloud_storage_encrypted
	mkdir -p /media/WebRPiservices_storage
	mount -t ext4 /dev/mapper/WebRPiServices_storage_encrypted /media/WebRPiServices_storage/
	chown www-data:www-data -R /media/WebRPiServices_storage
	;;
2)
	cryptsetup luksOpen $1 StorageRPi_storage_encrypted
	mkdir -p /media/StorageRPi_storage
	mount -t ext4 /dev/mapper/StorageRPi_storage_encrypted /media/StorageRPi_storage/
	chown www-data:www-data -R /media/StorageRPi_storage
	;;
3)
	echo "You need also to send, as script parameters, the name you want to give to the mapper for the encrypted partition (without spaces), and then the path to the mounting point."
	if [ -z "$2" ]; then # Encrypted partition name (mapper)
		echo "You did not gave a name for the encrypted partition."
		exit 1
	fi

	if [ -z "$3" ] && [ ! -s "$3" ]; then # Correspond au point de montage
		echo "You did not gave a path for the mounting point or the path is not valid."
		exit 1
	fi

	cryptsetup luksOpen $1 $2
	mkdir -p $3
	mount -t ext4 /dev/mapper/$2 $3
	;;
*)
	echo "Error in your selection."
esac
