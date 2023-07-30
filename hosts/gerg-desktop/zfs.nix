_: {
  config,
  lib,
  ...
}: {
  #link some stuff
  systemd.tmpfiles.rules = [
    "L+ /etc/ssh/ssh_host_ed25519_key  - - - - /persist/ssh/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub  - - - - /persist/ssh/ssh_host_ed25519_key.pub"
    "L  /etc/nixos/flake.nix  - - - - /home/gerg/Projects/nixos/flake.nix"
  ];
  #create machine-id for spotify
  environment.etc."machine-id".text = "b6431c2851094770b614a9cfa78fb6ea";
  #make sure the sopskey is found
  sops.age.sshKeyPaths = lib.mkForce ["/persist/ssh/ssh_host_ed25519_key"];
  fileSystems."/persist".neededForBoot = true;
  boot = {
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    #disable hibernate and set cache max
    kernelParams = ["nohibernate" "zfs.zfs_arc_max=17179869184"];
    supportedFilesystems = ["zfs" "vfat"];
    initrd = {
      #module for multiple swap devices
      kernelModules = ["dm_mod"];
      #keyboard module for zfs password
      availableKernelModules = ["hid_generic"];
      #wipe / and /var on boot
      postDeviceCommands = lib.mkAfter ''
        #wipe everything
         zfs rollback -r rpool/root@empty
         zfs rollback -r rpool/var@empty
      '';
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
      };
    };
  };
  systemd.services.zfs-mount.enable = false;
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  _file = ./zfs.nix;
}
