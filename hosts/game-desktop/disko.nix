{ disko, ... }:
{
  imports = [ disko.nixosModules.disko ];
  disko.devices.disk.nvme0n1 =
    let
      baseDevice = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPNPZ-512G-1006_21311N802456";
    in
    {
      device = baseDevice;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            device = "${baseDevice}-part1";
            start = "1MiB";
            end = "1GiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            device = "${baseDevice}-part2";
            start = "1GiB";
            end = "100%";
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
  _file = ./disko.nix;
}
