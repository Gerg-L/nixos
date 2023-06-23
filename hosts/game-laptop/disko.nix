{disko, ...}: {disks ? [], ...}: {
  dummyvalue = {inherit disks;};
  imports = [disko.nixosModules.disko];
  disko.devices = {
    disk.nvme0n1 = {
      device = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPNPZ-512G-1006_21311N802456";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "1GiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "root";
            start = "1GiB";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };
  };
}
