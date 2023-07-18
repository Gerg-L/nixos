{disko, ...}: {lib, ...}: let
  disks = [
    "nvme-SHPP41-500GM_SSB4N6719101A4N22"
    "nvme-SHPP41-500GM_SSB4N6719101A4N0E"
  ];
in {
  imports = [disko.nixosModules.disko];
  disko.devices = {
    disk = lib.mkMerge (map (x: {
        ${x} = {
          type = "disk";

          device = "/dev/disk/by-id/${x}";
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
                  mountpoint = "/boot/efis/${x}";
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
      })
      disks);
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
            postCreateHook = ''
              zfs snapshot rpool/root@empty
              zfs snapshot rpool/root@lastboot
            '';
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
            postCreateHook = ''
              zfs snapshot rpool/var@empty
              zfs snapshot rpool/var@lastboot
            '';
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
            postCreateHook = "zfs snapshot bpool/boot@empty";
          };
        };
      };
    };
  };
}
