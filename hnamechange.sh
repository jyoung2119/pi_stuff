#!/bin/bash

HOSTNM ="/etc/hostname"

if grep -Fq "raspberrypi" $HOSTNM
then
  sed -i "s/raspberrypi/rpiGate/" $HOSTNM
else
  echo "rpiGate" >> $HOSTNM
fi

HOST = "/etc/hosts"

if grep -Fq "raspberrypi" $HOST
then
  sed -i "s/raspberrypi/rpiGate/" $HOST
else
  echo "no hosts"
fi

sudo reboot -n
