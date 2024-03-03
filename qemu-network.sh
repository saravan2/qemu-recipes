#!/bin/bash
# Optional nic setup
# Lets add kernel modules to our qemu disk to bring up the nic
# Mount the disk
# sudo mount -o loop qemu-hd.img qemu-mount
# sudo cp ../linux/drivers/net/mii.ko qemu-mount/var/modules/./
# sudo cp ../linux/drivers/net/ethernet/intel/e1000/e1000.ko qemu-mount/var/modules/./
# insmod mii.ko and then insmod e1000.ko
# sudo umount qemu-mount

# Start libvirtd to create the virtual bridge virbr0
# systemctl start libvirtd.service
systemctl status libvirtd.service
echo ""
brctl show
# bridge name	bridge id		STP enabled	interfaces
# virbr0		8000.525400a816b7	yes
echo ""
sudo tunctl -b -t tap0
echo ""
sudo ip link set dev tap0 up
echo ""
sudo brctl addif virbr0 tap0
brctl show
# bridge name	bridge id		STP enabled	interfaces
# virbr0		8000.525400a816b7	yes		tap0
echo ""
ip link
#1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#2: eno2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
#    link/ether 74:5d:22:0c:2d:5e brd ff:ff:ff:ff:ff:ff
#    altname enp0s31f6
#3: wlo1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DORMANT group default qlen 1000
#    link/ether d4:e9:8a:33:aa:5e brd ff:ff:ff:ff:ff:ff
#    altname wlp0s20f3
#11: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
#    link/ether 52:54:00:a8:16:b7 brd ff:ff:ff:ff:ff:ff
#17: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master virbr0 state UP mode DEFAULT group default qlen 1000
#    link/ether 32:87:07:9a:99:63 brd ff:ff:ff:ff:ff:ff