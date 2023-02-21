#!/bin/sh
DISK='/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22 /dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E'

INST_PARTSIZE_SWAP=16
INST_PARTSIZE_RPOOL=

set -e

for i in ${DISK}; do

blkdiscard -f $i

sgdisk --zap-all $i
sgdisk -a1 -n1:24K:+1000K -t1:EF02 $i
sgdisk -n2:01M:+1G -t2:EF00 $i
sgdisk -n3:0:+4G -t3:BE00 $i
sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200  $i

if test -z $INST_PARTSIZE_RPOOL; then
	sgdisk -n5:0:0 -t5:BF00 $i
else
	sgdisk -n5:0:+${INST_PARTSIZE_RPOOL}G -t5:BF00 $i
fi

sync && udevadm settle && sleep 3

cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
mkswap /dev/mapper/${i##*/}-part4
swapon /dev/mapper/${i##*/}-part4
done

zpool create \
-o compatibility=grub2 \
-o ashift=12 \
-o autotrim=on \
-O acltype=posixacl \
-O canmount=off \
-O compression=lz4 \
-O devices=off \
-O normalization=formD \
-O relatime=on \
-O xattr=sa \
-O mountpoint=/boot \
-R /mnt \
bpool \
mirror \
$(for i in ${DISK}; do
	printf "$i-part3 ";
	done)

zpool create \
-o ashift=12 \
-o autotrim=on \
-R /mnt \
-O acltype=posixacl \
-O canmount=off \
-O compression=zstd \
-O dnodesize=auto \
-O normalization=formD \
-O relatime=on \
-O xattr=sa \
-O mountpoint=/ \
rpool \
mirror \
$(for i in ${DISK}; do
	printf "$i-part5 ";
	done)

zfs create \
-o canmount=off \
-o mountpoint=none \
-o encryption=on \
-o keylocation=prompt \
-o keyformat=passphrase \
rpool/nixos

zfs create -o mountpoint=legacy rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/

zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs rpool/nixos/home /mnt/home

zfs create -o mountpoint=legacy rpool/nixos/var
mkdir /mnt/var
mount -t zfs rpool/nixos/var /mnt/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
mkdir /mnt/var/lib
mount -t zfs rpool/nixos/var/lib /mnt/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log
mkdir /mnt/var/log
mount -t zfs rpool/nixos/var/log /mnt/var/log

zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot
zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

for i in ${DISK}; do
  mkfs.vfat -n EFI ${i}-part2
  mkdir -p /mnt/boot/efis/${i##*/}
  mount -t vfat ${i}-part2 /mnt/boot/efis/${i##*/}
done
