{
  config,
  lib,
}:
{
  #link some stuff
  systemd.tmpfiles.rules = [
    "L+ /etc/zfs/zpool.cache - - - - /persist/zfs/zpool.cache"
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
    supportedFilesystems.ntfs = true;

    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
    };

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
  };
}
