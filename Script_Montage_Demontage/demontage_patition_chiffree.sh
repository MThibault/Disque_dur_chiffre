#################################################################
#	Script de démontage d'une partition chiffrée		#
#		Dev par Thibault MILLANT			#
#################################################################

read -p "Voulez vous démonter la partition de stockage de Nextcloud (yes/no) : " choix
if [ $choix = "yes" ]; then
	umount /media/Millant_1To_Io_N/Nextcloud_storage
	cryptsetup luksClose Nextcloud_storage_crypted
	rm -r /media/Millant_1To_Io_N/Nextcloud_storage/
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
