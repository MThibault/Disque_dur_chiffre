#################################################################
#	Script de démontage d'une partition chiffrée		#
#		Dev par Thibault MILLANT			#
#################################################################

read -p "Voulez vous démonter la partition de stockage d'Owncloud (yes/no) : " choix
if [ $choix = "yes" ]; then
	umount /media/Millant_1To_Io_N/Owncloud_storage
	cryptsetup luksClose Owncloud_storage_crypted
	rm -r /media/Millant_1To_Io_N/Owncloud_storage/
elif [ $choix = "no" ]; then
	echo -e "Il faut entrer deux arguments : le nom de la partition chiffrée présent dans /dev/mapper/, et le point de montage.\n"
	if [ -z $1 ]; then
		echo -e "\nVous n'avez pas saisi de nom.\n"
		exit
	fi

	if [ -z $2 ]; then
		echo -e "\nVous n'avez pas saisie de point de montage.\n"
		exit
	fi

	umount $2
	cryptsetup luksClose $1
	rm -r $2
else
	echo -e "\nVotre choix ne correspond pas aux choix attendus !\n"
fi
