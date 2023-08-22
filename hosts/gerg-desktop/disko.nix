{disko, ...}: _: {
  imports = [disko.nixosModules.disko];
  disko.devices = {
    disk = {
      "0E" = let
        baseDevice = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E";
      in {
        type = "disk";
        device = baseDevice;
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              device = "${baseDevice}-part1";
              type = "EF00";
              start = "0";
              end = "4G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi0E";
              };
            };
            swap = {
              device = "${baseDevice}-part2";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            zfsroot = {
              device = "${baseDevice}-part3";
              start = "21G";
              end = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
      "22" = let
        baseDevice = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22";
      in {
        type = "disk";
        device = baseDevice;
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              device = "${baseDevice}-part1";
              type = "EF00";
              start = "0";
              end = "4G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi22";
              };
            };
            swap = {
              device = "${baseDevice}-part2";
              start = "5G";
              end = "21G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            zfsroot = {
              device = "${baseDevice}-part3";
              start = "21G";
              end = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
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
            postCreateHook = "zfs snapshot rpool/root@empty";
          };
          "nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            postCreateHook = "zfs snapshot rpool/nix@empty";
          };
          "var" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var";
            postCreateHook = "zfs snapshot rpool/var@empty";
          };
          "persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
            postCreateHook = "zfs snapshot rpool/persist@empty";
          };
          "home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
            postCreateHook = "zfs snapshot rpool/home@empty";
          };
        };
      };
    };
  };
  _file = ./disko.nix;
}
