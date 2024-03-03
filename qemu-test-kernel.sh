#!/bin/bash 
## Assumes that the kernel is built at ../linux/ and the qemu-hd.img is properly formatted
## libvirt is installed and the virtual bridge virbr0 is created
## tap0 interface is created and added to the virtual bridge virbr0
## mac has been installed via pip install . 

# Optional nic setup
# Lets add kernel modules to our qemu disk to bring up the nic
# Mount the disk
# sudo mount -o loop qemu-hd.img qemu-mount
# sudo cp ../linux/drivers/net/mii.ko qemu-mount/var/modules/./
# sudo cp ../linux/drivers/net/ethernet/intel/e1000/e1000.ko qemu-mount/var/modules/./
# insmod mii.ko and then insmod e1000.ko
# sudo umount qemu-mount

# Make sure CONFIG_BINFMT_MISC=y and CONFIG_IKCONFIG_PROC=y is set

sudo qemu-system-x86_64 -kernel ../linux/vmlinux -drive file=qemu-hd.img,index=0,media=disk,format=raw -append "root=/dev/sda rw console=ttyS0 selinux=0 nokaslr quiet" -cpu host -smp 4 -m 16G -netdev 'tap,id=net0,ifname=tap0,script=no,downscript=no' -device e1000,netdev=net0,mac=$(mac -g qemu -s) --enable-kvm --nographic
# Login using root and the password set in the first boot

# Inside the emulator load the kernel modules for the nic
# root@localhost:~# insmod /var/modules/mii.ko 
# root@localhost:~# insmod /var/modules/e1000.ko 
# root@localhost:~# ip link 
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
# 2: ens3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#    link/ether 52:54:00:38:2c:5e brd ff:ff:ff:ff:ff:ff
#    altname enp0s3
# root@localhost:~# ip link set ens3 up
# root@localhost:~# ip link 
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
#    link/ether 52:54:00:38:2c:5e brd ff:ff:ff:ff:ff:ff
#    altname enp0s3
# root@localhost:~# dhclient -v ens3
# root@localhost:~# apt update && apt upgrade
# Create a script to setup the network access inside the emulator
#!/bin/bash
#insmod /var/modules/mii.ko
#insmod /var/modules/e1000.ko
#dhclient -v ens3
# root@localhost:~# ./setup-net-access.sh 
# Internet Systems Consortium DHCP Client 4.4.3-P1
#Copyright 2004-2022 Internet Systems Consortium.
#All rights reserved.
#For info, please visit https://www.isc.org/software/dhcp/
#
#Listening on LPF/ens3/52:54:00:cb:62:4c
#Sending on   LPF/ens3/52:54:00:cb:62:4c
#Sending on   Socket/fallback
#DHCPREQUEST for 192.168.124.90 on ens3 to 255.255.255.255 port 67
#DHCPREQUEST for 192.168.124.90 on ens3 to 255.255.255.255 port 67
#DHCPNAK from 192.168.124.1
#DHCPDISCOVER on ens3 to 255.255.255.255 port 67 interval 5
#DHCPOFFER of 192.168.124.201 from 192.168.124.1
#DHCPREQUEST for 192.168.124.201 on ens3 to 255.255.255.255 port 67
#DHCPACK of 192.168.124.201 from 192.168.124.1
#bound to 192.168.124.201 -- renewal in 1604 seconds.