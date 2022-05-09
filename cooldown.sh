#!/usr/bin/bash

CPU_TEMP=$(< /sys/class/thermal/thermal_zone0/temp)

# max temp threshold
MAX_TEMP=60000

# port to change state of
PORT="1-1"

PORT_STATE=$(sudo uhubctl -l $PORT | tail -1 | awk '{print $4}')

TIMESTAMP=$(date +"%D %T")

if [ $CPU_TEMP -gt $MAX_TEMP ]; then
  if [ $PORT_STATE == "off" ]
  then
    sudo uhubctl -l $PORT -a on > /dev/null 2>&1
    printf "$TIMESTAMP | Current Temperature: ${CPU_TEMP:0:2}°C | Fan: ON \n" >> pi-cooldown.log
  fi
else
  if [ $PORT_STATE == "power" ]
  then
     sudo uhubctl -l $PORT -a off > /dev/null 2>&1
     printf "$TIMESTAMP | Current Temperature: ${CPU_TEMP:0:2}°C | Fan: OFF \n" >> pi-cooldown.log
  fi
fi
