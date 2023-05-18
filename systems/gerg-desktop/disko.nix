{
  inputs,
  disks ? [],
  ...
}: {
  dummyvalue = {inherit disks;};
  imports = [inputs.disko.nixosModules.disko];
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
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = ["bios_grub"];
            }
            {
              name = "ESP";
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
              start = "1G";
              end = "5G";
              content = {
                type = "zfs";
                pool = "bpool";
              };
            }
            {
              name = "swap";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
            {
              name = "zfsroot";
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
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = ["bios_grub"];
            }
            {
              name = "ESP";
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
              start = "1G";
              end = "5G";
              content = {
                type = "zfs";
                pool = "bpool";
              };
            }
            {
              name = "swap";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
            {
              name = "zfsroot";
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
          compression = "zstd";
          dnodesize = "auto";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          encryption = "on";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
          "nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          "var" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var";
          };
          "persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
          "home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
        };
      };
      bpool = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          compression = "lz4";
          devices = "off";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          canmount = "off";
        };

        options = {
          compatibility = "grub2";
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "boot" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/boot";
          };
        };
      };
    };
  };
}
