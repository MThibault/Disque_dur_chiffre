#!/usr/bin/env bash

#################################################
#	Create an encrypted partition		#
#################################################

## Author : Thibault MILLANT

## CHANGELOG :
## - Script creation. Need to be tested

## Test Mode
## If test mode equal 1, no command are run, only displayed
TEST_MODE=0


#########################
#	Function	#
#########################
function chooseCipher() {
	echo "I only offer xts cipher rather than cbc as they are safer."
	echo "1 - aes-xts-plain64"
	echo "2 - serpent-xts-plain64"
	echo "3 - twofish-xts-plain64"
	read -p "Select the number corresponding to the cipher you want to use : " chosen_cipher
	echo ""
}

function chooseKeySize() {
	echo "Key size for xts cipher."
	echo "1 - 256b"
	echo "2 - 512b"
	read -p "Select the number corresponding to the key size you want to use : " chosen_keysize
	echo ""
}

function chooseKeyFile() {
	echo "What do you want to use to manage encryption/decryption ?"
	echo "1 - Key File"
	echo "2 - Passphrase"
	read -p "Select the number corresponding to the method you want to use to encrypt and decrypt the partition : " chosen_method

	if [ "$chosen_method" = 1 ]; then
		read -p "Enter the path to the file you want to use for encryption/decryption : " key_file_path
		if [ ! -s "$key_file_path" ]; then
			echo "The file chosen does not exist !"
			exit 1
		fi
	fi
	echo ""
}

function chooseFileFormat() {
	echo "1 - ext2"
	echo "2 - ext3"
	echo "3 - ext4"
	echo "4 - fat"
	echo "5 - exfat"
	echo "6 - ntfs"
	echo "7 - btrfs"
	read -p "Select the number corresponding to the filesystem format you want to use for your partition : " chosen_file_format
	echo ""
}

function chooseMapper() {
	read -p "Choose a name, without space, for the partition mapping : " chosen_mapper_name
	if [ -z "$chosen_mapper_name" ]; then
		echo "You didn't enter any name."
		exit 1
	fi
	echo ""
}


## Script Start
#########################
#	PART 1		#
#########################
## Choose the partition you want to work on and send it as a script parameter
echo "At least, you need to send to the script, as first parameter, the partition you want to set up (example : /dev/sdb1)."
if [ -z $1 ]; then
	echo "You forgot to enter the parameter related to the partition when you called the script (first parameter)."
	exit 1
fi
echo ""

## Perform a benchmark using cryptsetup
read -p "Do you want to see what encryption settings are supported by your OS (Y/n) : " benchmark
if [ "${benchmark,,}" = "y" ]; then
	cryptsetup benchmark
fi
echo ""

## Beginning of the command line
cmd="cryptsetup -v"

## Choose the cipher
cmd="$cmd --cipher"
chooseCipher
case "$chosen_cipher" in
1) cmd="$cmd aes";;
2) cmd="$cmd serpent";;
3) cmd="$cmd twofish";;
*)
	echo "Your answer for the cipher selection is not valid."
	exit 1
	;;
esac
cmd="$cmd-xts-plain64"

## Choose key size
cmd="$cmd --key-size"
chooseKeySize
case "$chosen_keysize" in
1) cmd="$cmd 256";;
2) cmd="$cmd 512";;
*) 
	echo "Your answer for the key size seletion is not valid"
	exit 1
	;;
esac

## Hash algorithm
cmd="$cmd --hash sha512"

## Iter Time
## Number of milliseconds to spend with PBKDF passphrase processing
cmd="$cmd --iter-time 5000"

## Key file or Passphrase
chooseKeyFile
case "$chosen_method" in
1) cmd="$cmd --key-file $key_file_path";;
2) ;;
*) 
	echo "Your answer for the encryption and decryption method is not valid"
	exit 1
	;;
esac

## Random Generator
cmd="$cmd --use-random"

## Verify passphrase
cmd="$cmd --verify-passphrase"

## Luks command
cmd="$cmd luksFormat"

## Partition
cmd="$cmd $1"

if [ "$TEST_MODE" -eq 1 ]; then
	## Test
	echo "$cmd"
else
	$cmd
fi


#########################
#	PART 2		#
#########################
cmd="cryptsetup open --type luks"

## Key file or Passphrase
case "$chosen_method" in
1) cmd="$cmd --key-file $key_file_path";;
2) ;;
*) 
	echo "Error Part 2 key file or passphrase"
	exit 1
	;;
esac

## Partition
cmd="$cmd $1"

## Mapper name
chooseMapper
cmd="$cmd $chosen_mapper_name"

if [ "$TEST_MODE" -eq 1 ]; then
	## Test
	echo "$cmd"
else
	$cmd
fi


#########################
#	PART 3		#
#########################
cmd="mkfs"

## File Format
chooseFileFormat
case "$chosen_file_format" in
1) cmd="$cmd -t ext2";;
2) cmd="$cmd -t ext3";;
3) cmd="$cmd -t ext4";;
4) cmd="$cmd -t fat";;
5) cmd="$cmd -t exfat";;
6) cmd="$cmd -t ntfs";;
7) cmd="$cmd -t btrfs";;
*) 
	echo "Your answer for file format is not valid"
	exit 1
	;;
esac

## Mapper name
cmd="$cmd /dev/mapper/$chosen_mapper_name"

if [ "$TEST_MODE" -eq 1 ]; then
	## Test
	echo "$cmd"
else
	$cmd
fi


#########################
#	PART 4		#
#########################
echo "To mount your encrypted partition, you can copy/paste this command (replace the mounting path) :"
cmd="mount"

## File Format
case "$chosen_file_format" in
1) cmd="$cmd -t ext2";;
2) cmd="$cmd -t ext3";;
3) cmd="$cmd -t ext4";;
4) cmd="$cmd -t fat";;
5) cmd="$cmd -t exfat";;
6) cmd="$cmd -t ntfs";;
7) cmd="$cmd -t btrfs";;
*) 
	echo "Your answer for file format is not valid"
	exit 1
	;;
esac

cmd="$cmd /dev/mapper/$chosen_mapper_name /mnt"

echo "$cmd"
