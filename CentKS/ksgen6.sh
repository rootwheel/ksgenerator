### CentOS 6 KS Generator ###
#!/bin/bash

cd `dirname $0`
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

# Template is sed -i "s/^what to search.*/change with/g" filename

sed -i "s/^rootpw.*/rootpw $rootpw/g" ks6
sed -i "s/^network --onboot.*/network --onboot=yes --bootproto=static --ip=$ipaddr --netmask=255.255.255.0 --gateway=$gateway --nameserver=1.1.1.1 --hostname=$dsuname/g" ks6
sed -i "s/^volgroup vg_.*/volgroup vg_$dsuname --pesize=4096 pv.008002/g" ks6
sed -i "s|^logvol \/.*|logvol \/ --fstype=ext4 --name=lv_root --vgname=vg_$dsuname --grow --size=1024 --maxsize=51200|g" ks6
sed -i "s/^logvol swap .*/logvol swap --name=lv_swap --vgname=vg_$dsuname --grow --size=2048 --maxsize=2048/g" ks6

./deploy ks6 put > /dev/null

echo "KS file will be removed in 10 minutes according to"

at now +10 minute <<< "./deploy.sh ks remove"

./telegram.sh <tg_group_id> $dsuname "KS6 file with IP: $ipaddr and password: $rootpw is ready to install" > /dev/null
