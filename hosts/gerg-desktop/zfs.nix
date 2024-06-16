{
  config,
  lib,
  pkgs,
}:
{

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
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/ssh/ssh_host_ed25519_key" ];
  fileSystems."/persist".neededForBoot = true;
  boot = {
    supportedFilesystems = {
      ntfs = true;
    };
    zfs = {
      package = pkgs.zfs_unstable;
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };
    kernelPackages = pkgs.linuxPackagesFor (
      let
        version = "6.8.12";
      in
      (pkgs.linuxManualConfig {
        version = "${version}-gerg";
        modDirVersion = "${version}-gerg";
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
          hash = "sha256-GbMZVtIptbnKVnH6HHQyAXloKj2NAPyGeUEUsh2oYDk=";
        };

        inherit (config.boot) kernelPatches;

        config = {
          CONFIG_RUST = "y";
          CONFIG_MODULES = "y";
        };
        configfile = ./kernelConfig;
      }).overrideAttrs
        (old: {
          passthru = (old.passthru or { }) // {
            features = lib.foldr (x: y: (x.features or { }) // y) {
              efiBootStub = true;
              netfilterRPFilter = true;
              ia32Emulation = true;
            } config.boot.kernelPatches;
          };
        })
    );

    #set ARC max
    kernelParams = [ "zfs.zfs_arc_max=17179869184" ];
    initrd = {
      kernelModules = [
        #module for multiple swap devices
        "dm_mod"
        #keyboard module for zfs password
        "hid_generic"
      ];
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
        enable = lib.mkForce true;
        extraFiles."shellx64.efi" = pkgs.edk2-uefi-shell.efi;

        extraEntries."windows.conf" = ''
          title  Windows
          efi     /shellx64.efi
          options -nointerrupt -noconsolein -noconsoleout HD2d65535a1:EFI\Microsoft\Boot\Bootmgfw.efi
        '';

      };
      grub.enable = lib.mkForce false;
      timeout = lib.mkForce 5;
      efi.efiSysMountPoint = "/efi22";
    };
  };
}
