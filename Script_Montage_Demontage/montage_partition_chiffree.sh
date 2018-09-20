#################################################################
#	Script de montage d'une partition chiffrée		#
#		Dev par Thibault MILLANT			#
#################################################################

## CHANGELOG :
## - Changing the code with Nextcloud instead of Owncloud

echo "Il faut au minimum donner en paramètre la partition concernée sous la forme /dev/xxxx."
if [ -z $1 ]; then # Correspond à la partition à utiliser
	echo "Vous n'avez pas saisi de partition à monter en tant que premier paramètre."
	exit
fi

read -p "Voulez vous monter la partition de stockage d'Owncloud/Nextcloud (yes/no) : " choix
if [ $choix = "yes" ]; then
	cryptsetup luksOpen $1 Nextcloud_storage_encrypted
	mkdir -p /media/Millant_1To_Io_N/Nextcloud_storage
	mount -t ext4 /dev/mapper/Nextcloud_storage_encrypted /media/Millant_1To_Io_N/Nextcloud_storage
	chown www-data:www-data -R /media/Millant_1To_Io_N/Nextcloud_storage/
elif [ $choix = "no" ]; then
	echo "Dans ce cas il vous faut aussi entrer le nom de la partition chiffrée, puis le point de montage."
	if [ -z $2 ]; then # Correspond au nom de la partition chiffrée
		echo "Vous n'avez pas saisi de nom en tant que second paramètre."
		exit
	fi

	if [ -z $3 ]; then # Correspond au point de montage
		echo "Vous n'avez pas saisie de point de montage en tant que troisième paramètre."
		exit
	fi

	cryptsetup luksOpen $1 $2
	mkdir -p $3
	mount -t ext4 /dev/mapper/$2 $3
else
	echo "Votre choix ne correspond pas aux choix attendus !"
fi
