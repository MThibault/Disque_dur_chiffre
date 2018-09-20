#################################################################
#	Script de démontage d'une partition chiffrée		#
#		Dev par Thibault MILLANT			#
#################################################################

## CHANGELOG :
## - Name changed to support Nextcloud

read -p "Voulez vous démonter la partition de stockage d'Owncloud/Nextcloud (yes/no) : " choix
if [ $choix = "yes" ]; then
	umount /media/WebRPiServices_storage
	cryptsetup luksClose WebRPiServices_storage_encrypted
	rm -r /media/WebRPiServices_storage
elif [ $choix = "no" ]; then
	echo -e "Il faut entrer deux arguments : le nom de la partition chiffrée présent dans /dev/mapper/, et le point de montage."
	if [ -z $1 ]; then
		echo -e "Vous n'avez pas saisi de nom."
		exit
	fi

	if [ -z $2 ]; then
		echo -e "Vous n'avez pas saisie de point de montage."
		exit
	fi

	umount $2
	cryptsetup luksClose $1
	rm -r $2
else
	echo -e "Votre choix ne correspond pas aux choix attendus !"
fi
