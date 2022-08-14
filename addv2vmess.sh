#!/bin/bash
RED='\033[0;31m' 
NC='\033[0m' 
GREEN='\033[0;32m' 
ORANGE='\033[0;33m' 
BLUE='\033[0;34m' 
PURPLE='\033[0;35m' 
CYAN='\033[0;36m' 
LIGHT='\033[0;37m'
          
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
                                                                                                                                                                                                      
MYIP=$(wget -qO- ipinfo.io/ip);                                                                                                                                                                                 
echo "Checking VPS" 
IZIN=$(curl -sS https://raw.githubusercontent.com/ketum9/s/main/ip | awk '{print $4}' | grep $MYIP ) 
if [[ $MYIP = $IZIN ]]; then 
echo -e "${GREEN}Permission Accepted...${NC}" 
else 
echo -e "${RED}Permission Denied!${NC}"; 
echo -e "${LIGHT}Please Contact Admin!!!\e[37m" 
rm -f addv2vmess
exit 0
fi
                                                                                                                                                           
clear
domain=$(cat /etc/mon/xray/domain)

none="$(cat ~/log-install.txt | grep -w "V2RAY VLESS WS NONE TLS" | cut -d: -f2|sed 's/ //g')"
xtls="$(cat ~/log-install.txt | grep -w "V2RAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"

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
read -p "SNI (bug): " sni 
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
MYIP=$(curl -sS ipv4.icanhazip.com)
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# websocket 
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/v2ray/config.json

# Grpc
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/v2ray/config.json

echo -e "### $user $exp" >> /etc/mon/v2ray/uservmess.txt

cat > /usr/local/etc/v2ray/$user-tls.json << EOF
            {
      "v": "2",
      "ps": "${user}",
      "add": "${dom}",
      "port": "${xtls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/v2vmess",
      "type": "none",
      "host": "${sni}",
      "tls": "tls"
}
EOF

cat > /usr/local/etc/v2ray/$user-none.json << EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${dom}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/v2vmess",
      "type": "none",
      "host": "${sni}",
      "tls": "none"
}
EOF

cat > /usr/local/etc/v2ray/$user-grpc.json << EOF
      {
      "v": "0",
      "ps": "${user}",
      "add": "${dom}",
      "port": "${xtls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "v2vmess-grpc",
      "type": "none",
      "host": "${sni}",
      "tls": "tls"
}
EOF

vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)

vmesslink1="vmess://$(base64 -w 0 /usr/local/etc/v2ray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /usr/local/etc/v2ray/$user-none.json)"
vmesslink3="vmess://$(base64 -w 0 /usr/local/etc/v2ray/$user-grpc.json)"

systemctl restart v2ray.service
service cron restart
echo -e "${CYAN}[Info]${NC} v2ray Start Successfully !"
sleep 1
clear
echo -e "================================="
echo -e "      V2RAY VMESS WS & GRPC  " 
echo -e "================================="
echo -e "Remarks   : ${user}"
echo -e "IP/Host   : ${MYIP}"
echo -e "Subdomain : ${dom}"
echo -e "Sni/Bug   : ${sni}"
echo -e "port tls  : ${xtls}"
echo -e "port none : ${none}"
echo -e "id        : ${uuid}"
echo -e "alterId   : 0"
echo -e "Security  : auto"
echo -e "================================="
echo -e "VMESS WS TLS LINK"
echo -e " ${vmesslink1}"
echo -e "================================="
echo -e "VMESS WS LINK"
echo -e " ${vmesslink2}"
echo -e "================================="
echo -e "VMESS GRPC TLS LINK"
echo -e " ${vmesslink3}"
echo -e "================================="
echo -e "Created     : $hariini"
echo -e "Expired On  : $exp"
echo -e "================================="
echo -e "ScriptMod By Manternet"
