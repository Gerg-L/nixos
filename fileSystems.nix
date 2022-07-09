{
  "/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  "/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
}
