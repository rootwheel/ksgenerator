#!/bin/bash

if [ -n "$1" -a "$2" = "put" ]
	then
	sshpass -p <sftppass> sftp -oIdentityFile=path sftpuser@sftproot.net:/ks <<EOF
put $1
EOF
	elif [ -n "$1" -a "$2" = "remove" ]
		then
		sshpass -p <sftppass> sftp -oIdentityFile=path sftpuser@sftproot.net:/ks <<EOF
rm $1
EOF
		else
printf '%b\n' "\nUsing: \ndeploy <filename> <action>  \n\t filename - name of kickstart file \n\t action -  put or remove\n"
fi
rm -f batch.txt
