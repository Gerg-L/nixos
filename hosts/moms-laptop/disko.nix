{disko, ...}: {
  imports = [disko.nixosModules.disko];
  disko.devices = {
    disk.sda = {
      device = "/dev/disk/by-id/ata-WDC_WDS240G2G0A-00JH30_180936803144";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            start = "1MiB";
            end = "1GiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            start = "1GiB";
            end = "100%";
            part-type = "primary";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
  _file = ./disko.nix;
}
