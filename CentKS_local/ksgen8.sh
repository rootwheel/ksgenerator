### CentOS 8 KS Generator ###
#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 191)
BLUE=$(tput setaf 4)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)

PXEPATH='/home/repo/mirror/mirror.yandex.ru/preseed/ks'
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

printf '%s\n'  "${YELLOW}======== Summary ========${NORMAL}"
printf '%s\n' "${BLUE}Entered hostname:${NORMAL} $dsuname"
printf '%s\n' "${BLUE}Entered IP:${NORMAL} ${BRIGHT}$ipaddr${NORMAL}"
gateway=$(echo $ipaddr | sed 's/[0-9]\+/1/4')
printf '%s\n' "${BLUE}Gateway IP:${NORMAL} $gateway"
rootpw=$(pwgen -s -n 12 1)
printf '%s\n' "${BLUE}SU password is:${NORMAL} ${RED}$rootpw${NORMAL}"

sed -i "s/^rootpw.*/rootpw $rootpw/g" ks8
sed -i "s/^network  --bootproto.*/network  --bootproto=static --device=link --gateway=$gateway --ip=$ipaddr --nameserver=1.1.1.1 --netmask=255.255.255.0 --ipv6=auto --activate/g" ks8
sed -i "s/^network  --hostname.*/network  --hostname=$dsuname/g" ks8

cp ks8 $PXEPATH
chown sftpuser. $PXEPATH/ks8

echo "KS file will be removed in 10 minutes according to at job"
at now +10 minute <<< "rm -f $PXEPATH/ks8" 2>/dev/null

printf '%s\n' "[$(date --rfc-3339=seconds)]: $*logged user $(last -1 | awk 'NR==1 {print $1,$3; exit}') creates a KS8 file for $dsuname $ipaddr $rootpw " >> /var/log/ksgen.log
