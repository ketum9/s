#!/bin/bash
RED='\033[0;31m' 
NC='\033[0m' 
GREEN='\033[0;32m' 
ORANGE='\033[0;33m' 
BLUE='\033[0;34m' 
PURPLE='\033[0;35m' 
CYAN='\033[0;36m' 
LIGHT='\033[0;37m'

# // CREATED XTLS
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //') 
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# // Getting
MYIP=$(wget -qO- ifconfig.me/ip); 
echo "Checking VPS" 
IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $MYIP ) 
if [[ $MYIP = $IZIN ]]; then 
echo -e "${GREEN}Permission Accepted...${NC}" 
else 
echo -e "${RED}Permission Denied!${NC}"; 
echo -e "${LIGHT}Please Contact Admin!!!\e[37m" 
rm -f addv2vless
exit 0
fi
clear

# // Add
IP=$( curl -s ipinfo.io/ip );
clear
source /var/lib/manpokr/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/mon/xray/domain)
else
domain=$(cat /etc/mon/xray/domain)
fi

MYIP=$(wget -qO- ipinfo.io/ip);
none="$(cat ~/log-install.txt | grep -w "V2RAY VLESS WS NTLS" | cut -d: -f2|sed 's/ //g')"
xtls="$(cat ~/log-install.txt | grep -w "V2RAY VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/v2ray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
read -p "SNI (bug) : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain

hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# Websocket
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/v2ray/config.json

# Grpc
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/v2ray/config.json

echo -e "### $user $exp" >> /etc/mon/v2ray/uservless.txt

# Link
vlesslink1="vless://${uuid}@${dom}:$xtls?path=/v2vless&security=tls&encryption=none&type=ws&sni=$sni#${user}"
vlesslink2="vless://${uuid}@${dom}:$none?path=/v2vless&encryption=none&type=ws&sni=$sni#${user}"
vlesslink3="vless://${uuid}@${dom}:${xtls}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=v2vless-grpc&sni=$sni#$user"

systemctl restart v2ray.service
echo -e "${CYAN}[Info]${NC} V2ray Start Successfully !"
sleep 1
clear
echo -e "================================="
echo -e "      V2RAY VLESS WS & GRPC"
echo -e "================================="
echo -e "Remarks   : ${user}"
echo -e "IP/host   : ${MYIP}"
echo -e "SubDomain : ${dom}"
echo -e "Sni/Bug   : ${sni}"
echo -e "port tls  : $xtls"
echo -e "port none : $none"
echo -e "id        : ${uuid}"
echo -e "================================="
echo -e "VLESS WS TLS LINK"
echo -e " ${vlesslink1}"
echo -e "================================="
echo -e "VLESS WS LINK"
echo -e " ${vlesslink2}"
echo -e "================================="
echo -e "VLESS GRPC TLS LINK"
echo -e " ${vlesslink3}"
echo -e "================================="
echo -e "Created        : $hariini"
echo -e "Expired On     : $exp"
echo -e "================================="
echo -e " ScriptMod By Manternet"
