# RPiDrive
Script to creating a Wifi enabled USB drive for use in 3D printers. 

This script automates the creation of a Wifi connected USB drive, it uses the mass storage OTG usb on the Raspberry Pi Zero.
There are many instrcutions on how to make a Wifi USB drive but many are outdated and don't work, so I worte a small script to automate the process. 

Instructions here is only for use on a Raspi Zero W but it should work on any other RasPi (I don't intend to test it on any other raspi)

Parts you need.
1. Raspberry Pi Zero W.
2. Short micro-USB cable.
3. SD card (4GB or more)
4. SD card reader/writer

Software you need
1. SD card image writer (I use etcher)
2. Putty (or any ssh client)
3. Raspbian Lite (headless)

optional
1. Puttygen to make ssh keys

Steps
1. write image to SD.
2. mount SD card
3. edit 'wpa_supplicant.conf' to match your wifi network.
4. use PuttyGen to generate keys (optional)
5. copy the public keys to authorized_keys (optional)
6. copy files to /boot partition of SD card
7. install the SD card on the Raspi Zero W
8. power up the RasPi Zero W on your 3D printer 
9. login to the the RasPi Zero W with Putty
10. Run '/boot/install.sh'
11. wait for it to reboot.
12. mount the samba share on your computer.
13. copy files to the shared drive
14. select the files to print.


how to for ssh, headless setup for Raspi, writing SDcard images can be found easily on many sites so I will not cover it here. 

Links
Raspbian Buster Lite
https://downloads.raspberrypi.org/raspbian_lite_latest
Raspbian Buster Lite
https://www.balena.io/etcher
PuTTY
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

Where to buy.
https://sg.cytron.io/p-raspberry-pi-zero-w (cheapest but out of stock)


