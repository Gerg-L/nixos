_: {
  config,
  lib,
  pkgs,
  ...
}: {
  #link some stuff
  systemd.tmpfiles.rules = [
    "L+ /etc/ssh/ssh_host_ed25519_key  - - - - /persist/ssh/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub  - - - - /persist/ssh/ssh_host_ed25519_key.pub"
    "L  /etc/nixos/flake.nix  - - - - /home/gerg/Projects/nixos/flake.nix"
  ];
  #create machine-id for spotify
  environment.etc."machine-id" = {
    text = "b6431c2851094770b614a9cfa78fb6ea";
    mode = "0644";
  };
  #make sure the sopskey is found
  sops.age.sshKeyPaths = lib.mkForce ["/persist/ssh/ssh_host_ed25519_key"];
  fileSystems = {
    "/persist".neededForBoot = true;
    "/efi22".options = ["nofail"];
    "/efi0E".options = ["nofail"];
  };

  boot = {
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    #disable hibernate and set cache max
    kernelParams = ["nohibernate" "zfs.zfs_arc_max=17179869184"];
    initrd = {
      supportedFilesystems = ["zfs" "vfat"];
      #module for multiple swap devices
      kernelModules = ["dm_mod"];
      #keyboard module for zfs password
      availableKernelModules = ["hid_generic"];
      systemd.services.rollback = {
        path = [pkgs.zfs];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig.DefaultDependencies = "no";
        wantedBy = ["initrd.target"];
        after = ["zfs-import.target"];
        before = ["sysroot.mount"];
        script = ''
          zfs rollback -r rpool/root@empty
          zfs rollback -r rpool/var@empty
        '';
      };
    };
    plymouth.enable = false;
    loader = {
      generationsDir.copyKernels = true;
      #override default
      systemd-boot = {
        enable = true;
        mirroredBoots = [
          "/efi0E"
          "/efi22"
        ];
      };
      efi.canTouchEfiVariables = false;
      grub = {
        enable = false;
        copyKernels = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        mirroredBoots = [
          {
            path = "/efi22";
            devices = ["nodev"];
          }
          {
            path = "/efi0E";
            devices = ["nodev"];
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
