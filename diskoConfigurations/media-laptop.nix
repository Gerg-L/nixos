_: {
  disk.sda =
    let
      baseDevice = "/dev/disk/by-id/ata-WDC_WDS240G2G0A-00JH30_180936803144";
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
}
