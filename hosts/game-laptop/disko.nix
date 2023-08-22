{disko, ...}: {
  imports = [disko.nixosModules.disko];
  disko.devices = {
    disk.nvme0n1 = {
      device = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPNPZ-512G-1006_21311N802456";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
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
