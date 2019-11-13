### CentOS 8 KS Generator ###
#!/bin/bash

cd "$(dirname "$0")"
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

sed -i "s/^rootpw.*/rootpw $rootpw/g" ks8
sed -i "s/^network  --bootproto.*/network  --bootproto=static --device=link --gateway=$gateway --ip=$ipaddr --nameserver=1.1.1.1 --netmask=255.255.255.0 --ipv6=auto --activate/g" ks8
sed -i "s/^network  --hostname.*/network  --hostname=$dsuname/g" ks8

./deploy.sh ks8 put

echo "KS file will be removed in 10 minutes according to"

at now +10 minute <<< "./deploy.sh ks8 remove"

./telegram.sh <tg_group_id> $dsuname "KS file with IP: $ipaddr and password: $rootpw is ready to install" > /dev/null
