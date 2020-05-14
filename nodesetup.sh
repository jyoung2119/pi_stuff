#!/bin/bash

# Install required package
sudo apt-get install -y batctl

# Create node script
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

# Make node script executable
sudo chmod +x ~/start-batman-adv.sh

# Edit permissions in order to create following file
sudo chmod 777 /etc/network/interfaces.d

# Create file that defines network interface for wlan0
sudo cat > /etc/network/interfaces.d/wlan0 <<- "EOF"
auto wlan0
iface wlan0 inet manual
    wireless-channel 1
    wireless-essid call-code-mesh
    wireless-mode ad-hoc
EOF

# Ensure the batman-adv kernel module is loaded at boot time
echo 'batman-adv' | sudo tee --append /etc/modules

# Stop the DHCP process from trying to manage the wireless lan interface
echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf

# Make sure node script gets called by adding line to end of rc.local
sudo sed -i '18 a /home/pi/start-batman-adv.sh &' /etc/rc.local

echo 'NODE SETUP COMPLETE'
echo 'IF PI STAYING AS NODE PLEASE SHUTDOWN'
