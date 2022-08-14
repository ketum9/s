#!/bin/bash
# My Telegram : https://t.me/Manternet
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
rm -f addv2trojan
exit 0
fi
clear

# // Add
source /var/lib/manpokr/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/mon/xray/domain)
else
domain=$IP
fi
domain=$(cat /etc/mon/xray/domain)

none="$(cat ~/log-install.txt | grep -w "V2RAY VLESS WS NTLS" | cut -d: -f2|sed 's/ //g')"
xtls="$(cat ~/log-install.txt | grep -w "V2RAY VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /usr/local/etc/v2ray/config.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
read -p "Expired (Days) : " masaaktif
read -p "SNI (bug) : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
uuid=$(cat /proc/sys/kernel/random/uuid)
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# Websocket
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/v2ray/config.json

# // Grpc
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/v2ray/config.json

echo -e "### $user $exp" >> /etc/mon/v2ray/usertrojan.txt

# // Link
trojanlink="trojan://${uuid}@${dom}:$xtls?type=ws&security=tls&path=/v2trojan-ws#${user}"
trojanlink0="trojan://${uuid}@${dom}:$none?host=${dom}&security=none&type=ws&path=/v2trojan-ws#${user}"
trojanlink1="trojan://${uuid}@$dom:${xtls}?mode=gun&security=tls&type=grpc&serviceName=v2trojan-grpc&sni=${sni}#${user}"

systemctl restart v2ray.service
service cron restart
echo -e "${CYAN}[Info]${NC} v2ray Start Successfully !"
sleep 1

clear
echo -e "================================="
echo -e "      V2RAY TROJAN WS & GRPC " 
echo -e "================================="
echo -e "Remarks   : ${user}"
echo -e "IP/Host   : ${IP}"
echo -e "Subdomain : ${dom}"
echo -e "Sni/Bug   : ${sni}"
echo -e "Port tls  : ${xtls}"
echo -e "Port none : ${none}"
echo -e "Password  : ${uuid}"
echo -e "================================="
echo -e "TROJAN WS TLS LINK"
echo -e " ${trojanlink}"
echo -e "================================="
echo -e "TROJAN WS LINK"
echo -e " ${trojanlink0}"
echo -e "================================="
echo -e "TROJAN GRPC TLS LINK"
echo -e " ${trojanlink1}"
echo -e "================================="
echo -e "Created : $hariini"
echo -e "Expired : $exp"
echo -e "================================="
echo -e " ScriptMod By Manternet"
