#!/bin/bash
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'
LIGHT='\033[0;37m'

# // Getting
curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/Manpokr/multi/main/backup/rclone.conf"
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y

cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

defaults
port 587
tls on
account default
host smtp.gmail.com
port 587
auth on
user smtp5313@gmail.com
from smtp5313@gmail.com
password wgrbymeckwjjnpht
logfile ~/.msmtp.log
EOF

chown -R www-data:www-data /etc/msmtprc

# // Downloads
cd /usr/bin
wget -O backup-info "https://raw.githubusercontent.com/Manpokr/multi/main/backup/backup-info.sh"
wget -O backup "https://raw.githubusercontent.com/Manpokr/multi/main/backup/backup.sh"
wget -O restore "https://raw.githubusercontent.com/Manpokr/multi/main/backup/restore.sh"
wget -O strt "https://raw.githubusercontent.com/Manpokr/multi/main/backup/strt.sh"
wget -O limit-speed "https://raw.githubusercontent.com/Manpokr/multi/main/backup/limit-speed.sh"
chmod +x backup-info
chmod +x backup
chmod +x restore
chmod +x strt
chmod +x limit-speed
cd
rm -f /root/set-br.sh

