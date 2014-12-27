#################################################################
#	Script de montage d'une partition chiffrée		#
#		Dev par Thibault MILLANT			#
#################################################################

echo "\nIl faut au minimum donner en paramètre la partition concernée sous la forme /dev/xxxx.\n"
if [ -z $1 ]; then # Correspond à la partition à utiliser
	echo "\nVous n'avez pas saisi de partition à monter en tant que premier paramètre.\n"
	exit
fi

read -p "Voulez vous monter la partition de stockage d'Owncloud (yes/no) : " choix
if [ $choix = "yes" ]; then
	cryptsetup luksOpen $1 Owncloud_storage_crypted
	mkdir -p /media/Millant_1To_Io_N/Owncloud_storage
	mount -t ext4 /dev/mapper/Owncloud_storage_crypted /media/Millant_1To_Io_N/Owncloud_storage
	chown www-data:www-data -R /media/Millant_1To_Io_N/Owncloud_storage/
elif [ $choix = "no" ]; then
	echo "\nDans ce cas il vous faut aussi entrer le nom de la partition chiffrée, puis le point de montage.\n"
	if [ -z $2 ]; then # Correspond au nom de la partition chiffrée
		echo "\nVous n'avez pas saisi de nom en tant que second paramètre.\n"
		exit
	fi

	if [ -z $3 ]; then # Correspond au point de montage
		echo "\nVous n'avez pas saisie de point de montage en tant que troisième paramètre.\n"
		exit
	fi

	cryptsetup luksOpen $1 $2
	mkdir -p $3
	mount -t ext4 /dev/mapper/$2 $3
else
	echo "\nVotre choix ne correspond pas aux choix attendus !\n"
fi
