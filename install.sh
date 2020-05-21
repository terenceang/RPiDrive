#!/bin/bash

#check if running as root
[ "$EUID" -ne 0 ] && { echo "Please run as root"; exit;}

#get ip address
my_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')

[ ! -f /boot/usbshare.sh ] && { echo "usbshare.sh not found"; exit;}
[ ! -f /boot/usbshare.service ] && { echo "usbshare.service not found"; exit;}

clear
echo "RasPi Zero W USB Share installation."
echo "------------------------------------"
echo "This script creates a Wifi connected USB drive on the Raspberry Pi Zero W"
echo ""
echo "Tested on 2020-02-13-raspbian-buster-lite.img"
echo ""
echo "The USB drive can be mounted on a Samba share,"
echo "accessible from '/$my_ip/usbshare'"
echo "user:pi, password:raspberry"
echo "to change samba password - use 'smbpasswd pi'"
echo ""
echo "Original source from various individuals online"
echo "- Terence Ang"
echo ""

read -n 1 -s -r -p "Press any key to continue"

if [ -f /boot/authorized_keys ]; then
    echo "Installing ssh public keys"
	echo ""
	cd /home/pi/
	mkdir .ssh
	mv /boot/authorized_keys .ssh/
fi

echo "install overlays, disable bluetooth"
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules  
echo "g_mass_storage" | sudo tee -a /etc/modules

mv /boot/usbshare.sh /usr/local/share/
mv /boot/usbshare.service /lib/systemd/system/
chmod -X /lib/systemd/system/usbshare.*
chmod -R 775 /lib/systemd/system/usbshare.*

echo "creating file"
dd if=/dev/zero of=/piusb_fat32.bin bs=1 count=0 seek=128M
mkdosfs /piusb_fat32.bin -n RPiDrive
echo "file created - formatted - fat32 - size - 128M - drive name - RPiDrive"

mkdir /mnt/usb_share
echo "/piusb_fat32.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab
mount -a
echo "image file mounted on /mnt/usb_share"

systemctl daemon-reload
systemctl enable usbshare.service

echo "install Samba - this will take a while"
apt-get update
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections
sudo apt-get install samba -y

echo "create samba share - usbshare"
echo "[usbshare]" | sudo tee -a /etc/samba/smb.conf
echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
echo "path = /mnt/usb_share" | sudo tee -a /etc/samba/smb.conf
echo "guest ok = no" | sudo tee -a /etc/samba/smb.conf
echo "read only = no" | sudo tee -a /etc/samba/smb.conf
echo "create mask = 777" | sudo tee -a /etc/samba/smb.conf
(echo "raspberry"; echo "raspberry") | sudo smbpasswd -s -a pi
smbpasswd -e pi

echo "samba share created - usbshare"

echo "reboot"
sleep 5s
reboot now