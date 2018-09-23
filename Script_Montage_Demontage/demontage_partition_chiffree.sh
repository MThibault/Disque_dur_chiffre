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
function choose_umount() {
	echo "1 - Umount the partition for Owncloud/Nextcloud"
	echo "2 - Umount a storage partition"
	echo "3 - Manual umounting"
	read -p "Select the number corresponding to your solution you want to use : " chosen_mount
	echo ""
}


## Start Script
choose_umount
case "$chosen_umount" in
1)
	umount /media/WebRPiServices_storage
	cryptsetup luksClose WebRPiServices_storage_encrypted
	rm -r /media/WebRPiServices_storage
	;;
2)
	umount /media/StorageRPi_storage
	cryptsetup luksClose StorageRPi_storage_encrypted
	rm -r /media/StorageRPi_storage
	;;
3)
	echo "You need to enter, as script parameter, 2 others parameters : the name of the encrypted partition (you can find it in /dev/mapper/), and the path of the mounting point."
	if [ -z $1 ]; then
		echo "You did not gave a name for the encrypted partition."
		exit 1
	fi

	if [ -z $2 ] && [ ! -s "$2" ]; then
		echo "You did not gave a path for the mounting point or the path is not valid."
		exit 1
	fi

	umount $2
	cryptsetup luksClose $1
	rm -r $2
	;;
*)	echo "Error in your selection.";;
esac
