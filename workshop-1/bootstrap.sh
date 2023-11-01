#!/bin/bash

set -e

# Create Partition ext4 in additional Disk
echo -e "g\nn\n1\n\n\nw" | sudo fdisk /dev/sdc
sudo pvcreate /dev/sdc1 && sudo vgcreate storage_vg /dev/sdc1
sudo lvcreate -l 100%FREE storage_vg -n storage_data
sudo mkfs.ext4 /dev/storage_vg/storage_data
sudo mkdir /storage_data
echo "# Mount Additional Disk" | sudo tee -a /etc/fstab && echo "/dev/storage_vg/storage_data /storage_data ext4 defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a

# Install Software
sudo apt update && sudo apt install -y nginx mariadb-server mariadb-common php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip unzip
wget https://wordpress.org/latest.tar.gz
sudo tar -xvf latest.tar.gz -C /var/www/