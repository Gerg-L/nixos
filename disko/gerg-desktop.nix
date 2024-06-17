lib: {

  disk =
    lib.genAttrs
      [
        "0E"
        "22"
      ]
      (
        name:
        let
          fullName = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N${name}";
        in
        {
          type = "disk";
          device = fullName;
          content = {
            type = "gpt";
            partitions = {
              BOOT = {
                device = "${fullName}-part1";
                type = "EF00";
                start = "0";
                end = "4G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/efi${name}";
                  mountOptions = [
                  "umask=007"
                  ];
                };
              };
              swap = {
                device = "${fullName}-part2";
                start = "5G";
                end = "21G";
                content = {
                  type = "swap";
                  randomEncryption = true;
                };
              };
              zfsroot = {
                device = "${fullName}-part3";
                start = "21G";
                end = "100%";
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        }
      );
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
        mountpoint = "none";
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
}
