_: {
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              type = "partition";
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = ["bios_grub"];
            }
            {
              name = "ESP";
              type = "partition";
              start = "1M";
              end = "1G";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N22";
              };
            }
            {
              name = "zfsboot";
              type = "partition";
              start = "1G";
              end = "5G";
              content = {
                type = "zfs";
                pool = "bpool";
              };
            }
            {
              name = "swap";
              type = "partition";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
            {
              name = "zfsroot";
              type = "partition";
              start = "21G";
              end = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            }
          ];
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "BIOS";
              type = "partition";
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = ["bios_grub"];
            }
            {
              name = "ESP";
              type = "partition";
              start = "1M";
              end = "1G";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N0E";
              };
            }
            {
              name = "zfsboot";
              type = "partition";
              start = "1G";
              end = "5G";
              content = {
                type = "zfs";
                pool = "bpool";
              };
            }
            {
              name = "swap";
              type = "partition";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
            {
              name = "zfsroot";
              type = "partition";
              start = "21G";
              end = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            }
          ];
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          compression = "zstd";
          dnodesize = "auto";
          normalization = "formD";
          relatime = "true";
          xattr = "sa";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "nixos" = {
            zfs_type = "filesystem";
            options = {
              canmount = "off";
              encryption = "on";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };

          "nixos/root" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };

          "nixos/home" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          "nixos/var" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/var";
          };
          "nixos/var/log" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/var/log";
          };
          "nixos/var/lib" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/var/lib";
          };
        };
      };
      bpool = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          compression = "lz4";
          devices = "off";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          mountpoint = "/boot";
        };

        options = {
          compatibility = "grub2";
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "nixos/root" = {
            zfs_type = "filesystem";
            options.mountpoint = "legacy";
            mountpoint = "/boot";
          };
        };
      };
    };
  };
}
