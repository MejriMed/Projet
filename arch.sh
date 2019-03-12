#!/bin/bash

source function.sh
#*************************** Script Principal *****************************	
#echo $#

if [ $# -gt 2 ];then 
	fnErreur
	exit
	fi 
	
	if [ $# -eq 2 ];then 
	if [ $1 != "-ar" ];then
		fnErreur
		exit
	else
		case $2 in
			-z) fnCompressGzip
			;;
			
			-j) fnCompressBzip2
			;;
			
			-J) fnCompressXz
			;;
			
			*)  fnErreur
		esac
		exit
	fi
	fi
	if [ $# -eq 1 ]; then
	case $1 in
		-re) fnRestore ;;
		-h) fnHelp ;;
		-help) fnHelp ;;
                -g) gui ;;
		-clean) fnClean ;;

		*) fnErreur
	esac
	exit
	fi	
	if [ $# -eq 0 ]; then
	while true;
	do
		fnMenu
	done
	fi


