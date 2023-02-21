#!/bin/sh
DISK='/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22 /dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E'
set -e
zpool import -f rpool
zpool import -f bpool
zfs load-key rpool/nixos
mount -t zfs rpool/nixos/root /mnt/

mount -t zfs rpool/nixos/home /mnt/home

mount -t zfs rpool/nixos/var /mnt/var
mount -t zfs rpool/nixos/var/lib /mnt/var/lib
mount -t zfs rpool/nixos/var/log /mnt/var/log

mount -t zfs bpool/nixos/root /mnt/boot

for i in ${DISK}; do
  mount -t vfat ${i}-part2 /mnt/boot/efis/${i##*/}
done
