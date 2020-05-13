#!/bin/bash

sudo apt-get install -y batctl

sudo cat > ~/start-batman-adv.sh <<- "EOF"
#!/bin/bash
# batman-adv interface to use
sudo batctl if add wlan0
sudo ifconfig bat0 mtu 1468

# Tell batman-adv this is a gateway client
sudo batctl gw_mode client

# Activates batman-adv interfaces
sudo ifconfig wlan0 up
sudo ifconfig bat0 up
EOF

sudo chmod +x ~/start-batman-adv.sh

# sudo cat > /etc/network/interfaces.d/wlan0 <<- "EOF"
sudo cat <<'EOF' >/etc/network/interfaces.d/wlan0
auto wlan0
iface wlan0 inet manual
    wireless-channel 1
    wireless-essid call-code-mesh
    wireless-mode ad-hoc
EOF

echo 'batman-adv' | sudo tee --append /etc/modules

echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf

sudo sed -i '18 a /home/pi/start-batman-adv.sh &' /etc/rc.local

echo 'NODE SETUP COMPLETE'
echo 'IF PI STAYING AS NODE PLEASE SHUTDOWN'
