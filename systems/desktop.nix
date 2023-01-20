{ config, pkgs, callPackage, lib, username, ... }:
{
  #important stuff first
  imports =
    [
      ../modules/amd.nix
      ../modules/packages.nix
      ../modules/boot.nix
      ../modules/fonts.nix
      ../modules/scripts.nix
      ../modules/vfio.nix
      ../modules/refreshrate.nix
      ../modules/xserver.nix
      ../modules/smb.nix
      ../modules/zsh.nix
    ];
  networking.hostName = "gerg-desktop";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  #end important stuff
  environment.systemPackages = with pkgs; [
    #afk-cmds
    xmrig
    t-rex-miner
    vscodium
  ];
  #user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "networkmanager" "kvm" "libvirtd" ];
    };
  };
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
    kernelModules = [ "kvm-amd" "msr" ];
    kernelParams = [ "iomem=relaxed" "msr.allow_writes=on" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e5c9634f-0273-4fd3-b35f-49899984340f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D3B9-197E";
      fsType = "vfat";
    };
  };
  #discord bot stuff
  virtualisation.docker.enable = false;
  systemd.services.parrot = {
    enable = true;
    path = with pkgs; [ parrot yt-dlp ffmpeg ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "NetworkManager-wait-online.service" ];
    after = [ "NetworkManager-wait-online.service" ];
    script = "parrot";
    serviceConfig = {
      EnvironmentFile = "/home/${username}/parrot/.env";
    };
  };
  #mining stuff
  systemd.services.mining = {
    enable = false;
    path = with pkgs; [ t-rex-miner afk-cmds st zsh dbus xmrig ];
    wants = [ "graphical.target" ];
    script = ''
      afk-cmds -c /home/${username}/afk-cmds.json
    '';
    environment = {
      #  PATH="/run/current-system/sw/bin"; missing something with dbus
      XAUTHORITY = "/home/${username}/.Xauthority";
      DISPLAY = ":0";
      XDG_DATA_DIRS = "/nix/var/nix/profiles/default/share:/run/current-system/sw/share";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
      NO_AT_BRIDGE = "1";
    };
  };
}

