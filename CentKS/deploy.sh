#!/bin/bash

if [ -n "$1" -a "$2" = "put" ]
	then
	printf '%s\n' "put $1" "quit" > batch.txt
	sshpass -p <sftppass> sftp -oBatchMode=no -b batch.txt sftpuser@sftproot.net:/ks
	elif [ -n "$1" -a "$2" = "remove" ]
		then
		printf '%s\n' "rm $1" "quit" > batch.txt
		sshpass -p <sftppass> sftp -oBatchMode=no -b batch.txt sftpuser@sftproot.net:/ks
		else
printf '%b\n' "\nUsing: \ndeploy <filename> <action>  \n\t filename - name of kickstart file \n\t action -  put or remove\n"
fi
rm -f batch.txt
