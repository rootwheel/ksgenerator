### CentOS 6 KS Generator ###
#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 191)
BLUE=$(tput setaf 4)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)

PXEPATH='/home/repo/mirror/mirror.yandex.ru/preseed/ks'
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

printf '%s\n'  "${YELLOW}======== Summary ========${NORMAL}"
printf '%s\n' "${BLUE}Entered hostname:${NORMAL} $dsuname"
printf '%s\n' "${BLUE}Entered IP:${NORMAL} ${BRIGHT}$ipaddr${NORMAL}"
gateway=$(echo $ipaddr | sed 's/[0-9]\+/1/4')
printf '%s\n' "${BLUE}Gateway IP:${NORMAL} $gateway"
rootpw=$(pwgen -s -n 12 1)
printf '%s\n' "${BLUE}SU password is:${NORMAL} ${RED}$rootpw${NORMAL}"


sed -i "s/^rootpw.*/rootpw $rootpw/g" ks6
sed -i "s/^network --onboot.*/network --onboot=yes --bootproto=static --ip=$ipaddr --netmask=255.255.255.0 --gateway=$gateway --nameserver=1.1.1.1 --hostname=$dsuname/g" ks6
sed -i "s/^volgroup vg_.*/volgroup vg_$dsuname --pesize=4096 pv.008002/g" ks6
sed -i "s|^logvol \/.*|logvol \/ --fstype=ext4 --name=lv_root --vgname=vg_$dsuname --grow --size=1024 --maxsize=51200|g" ks6
sed -i "s/^logvol swap .*/logvol swap --name=lv_swap --vgname=vg_$dsuname --grow --size=2048 --maxsize=2048/g" ks6

cp ks6 $PXEPATH
chown sftpuser. $PXEPATH/ks6

echo "KS file will be removed in 10 minutes according to at job"
at now +10 minute <<< "rm -f $PXEPATH/ks6" 2>/dev/null

printf '%s\n' "[$(date --rfc-3339=seconds)]: $*logged user $(last -1 | awk 'NR==1 {print $1,$3; exit}') creates a KS6 file for $dsuname $ipaddr $rootpw " >> /var/log/ksgen.log
