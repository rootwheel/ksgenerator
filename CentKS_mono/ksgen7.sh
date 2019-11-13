### CentOS 7 KS Generator ###
#!/bin/bash
cd "$(dirname "$0")"

function ksdirect() {
sshpass -p <sftppass> sftp -oIdentityFile=path sftpuser@sftproot.net:/ks <<EOF
put ks7
EOF
		    }

ipaddr=''
while [ "$ipaddr" = "" ]; do
    echo -n "Please enter IP for new KS file: "
    read ipaddr
done

dsuname=''
while [ "$dsuname" = "" ]; do
    echo -n "Now enter hostname: "
    read dsuname
done

echo "======== Summary ========"
echo "Entered hostname: $dsuname"
echo "Entered IP: $ipaddr"
gateway=$(echo $ipaddr | sed 's/[0-9]\+/1/4')
echo "Gateway IP: $gateway"
rootpw=$(pwgen -s -n 12 1)
echo "SU password is: $rootpw"

sed -i "s/^rootpw.*/rootpw $rootpw/g" ks7
sed -i "s/^network  --bootproto.*/network  --bootproto=static --device=link --gateway=$gateway --ip=$ipaddr --nameserver=1.1.1.1 --netmask=255.255.255.0 --ipv6=auto --activate/g" ks7
sed -i "s/^network  --hostname.*/network  --hostname=$dsuname/g" ks7

ksdirect

echo "KS file will be removed in 10 minutes according to"
printf '%s\n' "rm ks7" "quit" > batch.txt
at now +10 minute <<< "sshpass -p <sftppass> sftp -oBatchMode=no -b batch.txt sftpuser@sftproot.net:/ks"

./telegram.sh <tg_group_id> $dsuname "KS file with IP: $ipaddr and password: $rootpw is ready to install" > /dev/null
