# Pi Cooldown
***
> Adapted from [Tim Etherington's](http://www.byfarthersteps.com/6802/) guide.

Bash scripts for automatic & manual control of USB-powered fan on Raspberry Pi. Supported Raspberry Pi models:
- B+
- 2B
- 3B
- 3B+
- 4B

## Table of Contents
***
- [Install](#install)
- [Usage](#usage)
  - [Automatic Control](#automatic-control)
  - [Manual Control](#manual-control)
    - [Turn ON](#turn-on)
    - [Turn OFF](#turn-off)
  - [Logs](#logs)

## Install
***

The `libusb-1.0` library is required for [uhubctl] (>=`1.0.16` recommended)

```sh
sudo apt-get install libusb-1.0-0-dev
```

Install the [uhubctl] system package

```sh
sudo apt install uhubctl
```

Clone this repository & provide the scripts read and write privileges

```sh
git clone https://github.com/feram18/pi-cooldown.git
cd pi-cooldown
sudo chmod 755 cooldown.sh power.sh
```

## Usage
***

Firstly, you will need to figure out the hub you want to control according to the Raspberry Pi model you have. 
From [uhubctl]'s documentation:
> ### Raspberry Pi B+, 2B, 3B
>
>  * Single hub `1-1`, ports 2-5 ganged, all controlled by port `2`:
>
>        uhubctl -l 1-1 -p 2 -a 0
>
>    Trying to control ports `3`,`4`,`5` will not do anything.
>    Port `1` controls power for Ethernet + WiFi.
>
> ### Raspberry Pi 3B+
>
>  * Main hub `1-1`, all 4 ports ganged, all controlled by port `2` (turns off secondary hub ports as well).
>    Port `1` connects hub `1-1.1` below, ports `2` and `3` are wired outside, port `4` not wired.
>
>        uhubctl -l 1-1 -p 2 -a 0
>
>  * Secondary hub `1-1.1` (daisy-chained to main): 3 ports,
>    port `1` is used for Ethernet + WiFi, and ports `2` and `3` are wired outside.
>
>
> ### Raspberry Pi 4B
>
> > :warning: If your VL805 firmware is older than `00137ad` (check with `sudo rpi-eeprom-update`), you have to 
> [update firmware](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md) to make power 
> switching work on RPi 4B.
>
>  * USB2 hub `1`, 1 port, only connects hub `1-1` below.
>
>  * USB2 hub `1-1`, 4 ports ganged, dual to USB3 hub `2` below:
>
>        uhubctl -l 1-1 -a 0
>
>  * USB3 hub `2`, 4 ports ganged, dual to USB2 hub `1-1` above:
>
>        uhubctl -l 2 -a 0
>
>  * USB2 hub `3`, 1 port, OTG controller. Power switching is [not supported](https://git.io/JUc5Q).

Once you have figured out the hub you want to control. Edit the `PORT` variable on both the `cooldown.sh` and `power.sh` 
scripts. By default, it is set to `1-1`. If you had to edit the default value, make sure to give the script privileges 
once again as previously demonstrated.

### Automatic Control

The `cooldown.sh` script handles the automatic control. By creating a cron job, you can set the script to run 
automatically at a given rate.

```sh
sudo crontab -e
```

Get the path to your `pi-cooldown` directory and add the following line at the bottom of the file, so that the script 
runs every 5 minutes and determines if the fan should be turned on:

`*/5 * * * * <path to your pi-cooldown directory>/cooldown.sh`

Your line will look something like `*/5 * * * * /home/pi/pi-cooldown/cooldown.sh`. You can also edit how frequent the 
script gets executed as you desire:

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of the month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
│ │ │ │ │                                      7 is also Sunday on some systems)
│ │ │ │ │
│ │ │ │ │
* * * * * <command to execute>
```

### Manual Control

The `power.sh` script allows you to manually control the power state of the Raspberry Pi's hub, by providing the `on` 
or `off` argument accordingly.

#### Turn ON

```sh
~/pi-cooldown/power.sh on
```

#### Turn OFF

```sh
~/pi-cooldown/power.sh off
```

### Logs

Both the `cooldown.sh` and `power.sh` write logs to the `pi-cooldown.log` file so you can keep track of the power state 
changes.

[uhubctl]: <https://github.com/mvp/uhubctl>
