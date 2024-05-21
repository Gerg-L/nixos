{ lanzaboote, _file }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [ pkgs.sbctl ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
    configurationLimit = 10;
  };

  #link some stuff
  systemd.tmpfiles.rules = [
    "L+ /etc/secureboot - - - - /persist/secureboot"
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
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/ssh/ssh_host_ed25519_key" ];
  fileSystems = {
    "/persist".neededForBoot = true;
    # These are my Windows drives partitions
    "/efi".device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S6PXNM0T402828A-part1";
    "/boot".device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S6PXNM0T402828A-part4";
    "/efi/EFI/Linux" = {
      device = "/boot/EFI/Linux";
      options = [ "bind" ];
    };
    "/efi/EFI/nixos" = {
      device = "/boot/EFI/nixos";
      options = [ "bind" ];
    };
  };

  boot = {
    kernelPatches = lib.singleton {
      name = "fix_amd_mem_access";
      patch = null;
      extraStructuredConfig.HSA_AMD_SVM = lib.kernel.yes;
    };
    zfs = {
      package = pkgs.zfs_unstable;
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    #disable hibernate and set cache max
    kernelParams = [ "zfs.zfs_arc_max=17179869184" ];
    initrd = {
      #module for multiple swap devices
      kernelModules = [ "dm_mod" ];
      #keyboard module for zfs password
      availableKernelModules = [ "hid_generic" ];
      systemd.services.rollback = {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig.DefaultDependencies = "no";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import.target" ];
        before = [ "sysroot.mount" ];
        path = [ config.boot.zfs.package ];
        script = ''
          zfs rollback -r rpool/root@empty
          zfs rollback -r rpool/var@empty
        '';
      };
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        xbootldrMountPoint = "/boot";
      };

      grub.enable = lib.mkForce false;
      timeout = lib.mkForce 5;
      efi.efiSysMountPoint = "/efi";
    };
  };
  inherit _file;
}
