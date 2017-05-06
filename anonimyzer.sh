#!/bin/bash
cat << EOF > /etc/resolv.conf 
nameserver 208.67.222.222 
nameserver 208.67.220.220
EOF

macchanger -A wlan0
macchanger -A eth0

cp -n /etc/hosts{,.old}
idomainname=$(domainname -i)
fdomainname=$(domainname -f)
newhn=$(sort -R /usr/share/wordlists/dirb/others/names.txt | head -n 1)
echo $newhn > /etc/hostname
mv /etc/hosts /etc/hosts.old
echo "127.0.0.1 localhost" > /etc/hosts
echo "$idomainname  $fdomainname    $newhn" >> /etc/hosts
echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
service hostname.sh stop
sleep 1
service hostname.sh start
service networking stop
sleep 1
service networking start
service network-manager stop
sleep 1
service network-manager start
xhost +$newhn
exit
