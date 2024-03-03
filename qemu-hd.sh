#!/bin/bash
# QEMU HD creation

## Image format raw, size 10G
qemu-img create qemu-hd.img 10g

## Format the disk with ext4 filesystem
mkfs.ext4 qemu-hd.img

## Mount the disk
mkdir qemu-mount
sudo mount -o loop qemu-hd.img qemu-mount

## Install debootstrap with stable release
sudo debootstrap --arch amd64 stable qemu-mount

## Create a /var/modules directory 
## to add kernel modules (nic) that can be
## insmod after the emulator boots with test kernel
sudo mkdir qemu-mount/var/modules

## Unmount the disk
sudo umount qemu-mount

## First boot to set up root passwd
## Requires a Linux kernel x86 boot executable
## Assign init to be /bin/bash shell 
# make -j$(nproc) bzImage
sudo qemu-system-x86_64 -kernel ../linux/arch/x86/boot/bzImage -drive file=qemu-hd.img,index=0,media=disk,format=raw -append "root=/dev/sda rw init=/bin/bash"
# Use passwd to set the root password 
# and shutdown the emulator