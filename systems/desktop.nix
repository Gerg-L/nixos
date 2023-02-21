inputs: {
  pkgs,
  settings,
  config,
  ...
}: {
  imports = [
    #	(import ../imports/boot.nix inputs)
    (import ../imports/dwm.nix inputs)
    (import ../imports/fonts.nix inputs)
    (import ../imports/git.nix inputs)
    (import ../imports/packages.nix inputs)
    (import ../imports/parrot.nix inputs)
    (import ../imports/picom.nix inputs)
    (import ../imports/refreshrate.nix inputs)
    (import ../imports/shells.nix inputs)
    (import ../imports/sxhkd.nix inputs)
    (import ../imports/theme.nix inputs)
    (import ../imports/vfio.nix inputs)
    #   (import ../imports/mining.nix inputs)
    (import ../imports/spicetify.nix inputs)
  ];
  system.stateVersion = "23.05";
  environment.systemPackages = with pkgs; [
    webcord # talk to people (gross)
    bitwarden #store stuff
    qbittorrent #steal stuff
    networkmanagerapplet #gui connection control
    vlc #play stuff
  ];
  networking = {
    hostName = settings.hostname;
    hostId = "288b56db";
  };
  hardware.cpu.amd.updateMicrocode = true;
  #user managment
  users = {
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "networkmanager"];
    };
  };
  boot = {
    zfs.devNodes = "/dev/disk/by-id/";
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = ["nohibernate" "zfs.zfs_arc_max=17179869184"];
    supportedFilesystems = ["zfs" "vfat"];
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "hid_generic"];
      includeDefaultModules = false;
    };
    loader = {
      efi = {
        canTouchEfiVariables = false;
      };
      generationsDir.copyKernels = true;
      systemd-boot.enable = false;
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
  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/var" = {
    device = "rpool/nixos/var";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/var/lib" = {
    device = "rpool/nixos/var/lib";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/var/log" = {
    device = "rpool/nixos/var/log";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/boot" = {
    device = "bpool/nixos/root";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N0E" = {
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
  fileSystems."/boot/efis/nvme-SHPP41-500GM_SSB4N6719101A4N22" = {
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
