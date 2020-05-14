#!/bin/bash

read -p "Enter Country Code: " country
echo "Country Code: $country"
read -p "Enter Network Name: " name
echo "Desired Network Name: $name"
read -p "Enter Network Password: " pword

sudo chmod 777 /etc/wpa_supplicant/wpa_supplicant.conf

sudo cat > /etc/wpa_supplicant/wpa_supplicant.conf <<- "EOF"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=GB
network={
    ssid="network name"
    scan_ssid=1
    psk="password"
}
EOF

sed -i -e"s/^country=.*/country=$country/" /etc/wpa_supplicant/wpa_supplicant.conf
sed -i -e"s/^ssid=.*/ssid=$name/" /etc/wpa_supplicant/wpa_supplicant.conf
sed -i -e"s/^psk=.*/psk=$pword/" /etc/wpa_supplicant/wpa_supplicant.conf

sudo chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf

sudo cat > ~/start-batman-adv.sh <<- "EOF"
#!/bin/bash
# batman-adv interface to use
sudo batctl if add wlan0
sudo ifconfig bat0 mtu 1468

# Tell batman-adv this is an internet gateway
sudo batctl gw_mode server

# Enable port forwarding between eth0 and bat0
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
sudo iptables -A FORWARD -i wlan1 -o bat0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i bat0 -o wlan1 -j ACCEPT

# Activates the interfaces for batman-adv
sudo ifconfig wlan0 up
sudo ifconfig bat0 up # bat0 is created via the first command
sudo ifconfig bat0 192.168.199.1/24
EOF

echo 'WIFI GATEWAY SETUP COMPLETE...PLEASE SHUTDOWN'
