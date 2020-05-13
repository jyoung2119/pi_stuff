#!/bin/bash

sudo sed -i '$ a interface=bat0\ndhcp-range=192.168.199.2,192.168.199.99,255.255.255.0,12h' /etc/dnsmasq.conf
# echo $'interface=bat0\ndhcp-range=192.168.199.2,192.168.199.99,255.255.255.0,12h' | sudo tee --append /etc/dnsmasq.conf

sudo rm start-batman-adv.sh

sudo cat > ~/start-batman-adv.sh <<-
