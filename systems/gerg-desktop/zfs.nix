_: {config, ...}: {
  boot = {
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };
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
        splashImage = null;
        extraConfig = ''
          GRUB_TIMEOUT_STYLE=hidden
        '';
      };
    };
  };
  systemd.services.zfs-mount.enable = false;
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
}
