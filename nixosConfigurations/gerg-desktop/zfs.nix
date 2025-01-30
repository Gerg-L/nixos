{
  config,
  lib,
  pkgs,
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
        #stage one internet
        "igc"
      ];

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          hostKeys = [ "/persist/initrd-keys/ssh_host_ed5519_key" ];
          authorizedKeys = [ config.local.keys.gerg_gerg-phone ];
        };
      };
      systemd = {
        network = {
          enable = true;
          networks.enp11s0 = {
            name = "enp11s0";
            address = [ "192.168.1.4/24" ];
            gateway = [ "192.168.1.1" ];
            dns = [ "192.168.1.1" ];
            DHCP = "no";
            linkConfig = {
              MACAddress = "D8:5E:D3:E5:47:90";
              RequiredForOnline = "routable";
            };
          };
          wait-online.enable = false;
        };
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
    };
  };

  systemd.shutdownRamfs = {
    enable = true;
    contents."/etc/systemd/system-shutdown/zfs-rollback".source =
      pkgs.writeShellScript "zfs-rollback" ''
        zfs='${lib.getExe config.boot.zfs.package}'
        zfs rollback -r rpool/root@empty
        zfs rollback -r rpool/var@empty
      '';
    storePaths = [ (lib.getExe config.boot.zfs.package) ];
  };

}
