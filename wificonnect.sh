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

sudo chmod 777 /etc/wpa_supplicant

sudo sed -i -e"s/^country=.*/country=$country/" /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i -e"s/^    ssid=.*/    ssid=""$name""/" /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i -e"s/^    psk=.*/    psk=""$pword""/" /etc/wpa_supplicant/wpa_supplicant.conf

sudo chmod 755 /etc/wpa_supplicant

sudo chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
