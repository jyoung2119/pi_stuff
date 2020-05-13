#!/bin/bash

sudo apt-get install -y dnsmasq

sudo sed -i '$ a interface=bat0\ndhcp-range=192.168.199.2,192.168.199.99,255.255.255.0,12h' /etc/dnsmasq.conf
# echo $'interface=bat0\ndhcp-range=192.168.199.2,192.168.199.99,255.255.255.0,12h' | sudo tee --append /etc/dnsmasq.conf

sudo rm start-batman-adv.sh

sudo cat > ~/start-batman-adv.sh <<- "EOF"
#!/bin/bash
# batman-adv interface to use
sudo batctl if add wlan0
sudo ifconfig bat0 mtu 1468

# Tell batman-adv this is an internet gateway
sudo batctl gw_mode server

# Enable port forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o bat0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i bat0 -o eth0 -j ACCEPT

# Activates batman-adv interfaces
sudo ifconfig wlan0 up
sudo ifconfig bat0 up
sudo ifconfig bat0 192.168.199.1/24
EOF

echo 'GATEWAY CREATED...SHUTDOWN PLEASE'
