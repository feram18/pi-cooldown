#!/usr/bin/bash

CPU_TEMP=$(< /sys/class/thermal/thermal_zone0/temp)

# port to change state of
PORT="1-1"

if [ $# -eq 0 ] ; then
    echo "$(tput setaf 1)Missing 'on' or 'off' argument"
elif [ $1 == "on" ] || [ $1 == "off" ]; then
    sudo uhubctl -l $PORT -a $1 > /dev/null 2>&1
    printf "$(date +"%D %T") | Current Temperature: ${CPU_TEMP:0:2}°C | Fan: ${1^^} \n" >> pi-cooldown.log
else
    echo "$(tput setaf 1)Invalid option. Please enter 'on' or 'off' option"
fi