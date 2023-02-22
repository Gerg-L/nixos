_: {config, ...}: {
  boot = {
    zfs.devNodes = "/dev/disk/by-id/";
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = ["nohibernate" "zfs.zfs_arc_max=17179869184"];
    supportedFilesystems = ["zfs" "vfat"];
    initrd = {
      kernelModules = ["dm_mod"];
      availableKernelModules = ["hid_generic"];
    };
    plymouth.enable = false;
    loader = {
      generationsDir.copyKernels = true;

      #override defaults
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;

      grub = {
        enable = true;
        efiInstallAsRemovable = true;
        version = 2;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
        mirroredBoots = [
          {
            path = "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N0E";
            devices = ["/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E"];
          }
          {
            path = "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N22";
            devices = ["/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22"];
          }
        ];
      };
    };
  };
  systemd.services.zfs-mount.enable = false;
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  fileSystems = {
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/var" = {
      device = "rpool/nixos/var";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/var/lib" = {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/boot" = {
      device = "bpool/nixos/root";
      fsType = "zfs";
      options = ["X-mount.mkdir"];
    };

    "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N0E" = {
      device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E-part2";
      fsType = "vfat";
      options = [
        "X-mount.mkdir"
        "x-systemd.idle-timout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
      ];
    };
    "/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N22" = {
      device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22-part2";
      fsType = "vfat";
      options = [
        "X-mount.mkdir"
        "x-systemd.idle-timout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
      ];
    };
  };
  swapDevices = [
    {
      device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N0E-part4";
      discardPolicy = "both";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
    {
      device = "/dev/disk/by-id/nvme-SHPP41-500GM_SSB4N6719101A4N22-part4";
      discardPolicy = "both";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];
}
