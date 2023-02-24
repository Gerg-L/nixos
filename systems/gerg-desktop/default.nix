inputs: {
  pkgs,
  settings,
  self,
  ...
}: {
  imports = [
    (import ./refreshrate.nix inputs)
    (import ./vfio.nix inputs)
    (import ./parrot.nix inputs)
    (import ./spicetify.nix inputs)
    #(import ./mining.nix inputs)
    (import ./zfs inputs)
  ];
  system.stateVersion = "23.05";

  localModules = {
    X11Programs = {
      sxhkd.enable = true;
      picom.enable = true;
    };
    DE.dwm.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };
  services.xserver.videoDrivers = ["amdgpu"];

  environment.systemPackages = [
    pkgs.webcord # talk to people (gross)
    pkgs.bitwarden #store stuff
    pkgs.qbittorrent #steal stuff
    pkgs.pavucontrol #gui volume control
    pkgs.pcmanfm #file manager
    pkgs.librewolf #best browser
    #pointless stuff
    pkgs.cava #pretty audio
    pkgs.pipes-rs # more fun things
    pkgs.vlc #play stuff
    inputs.suckless.packages.${pkgs.system}.st
  ];
  #set webcord theme
  systemd.tmpfiles.rules = ["L+ /home/gerg/.config/WebCord/Themes/black - - - - ${self}/misc/black.theme.css"];

  networking = {
    hostName = settings.hostname;
    hostId = "288b56db";
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    defaultGateway = "192.168.1.1";
    interfaces = {
      "enp11s0" = {
        name = "eth0";
      };
      "bridge0" = {
        name = "bridge0";
        macAddress = "D8:5E:D3:E5:47:90";
        ipv4.addresses = [
          {
            address = "192.168.1.4";
            prefixLength = 24;
          }
        ];
      };
    };
    bridges."bridge0".interfaces = ["eth0"];
  };
  #user managment
  users = {
    mutableUsers = false;
    users = {
      "${settings.username}" = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["wheel" "audio"];
        initialHashedPassword = "$6$hgiDFHEMVEA39Snj$Huxf2a/yd/gSO2ZwntxI5Z65c1kCf35lvbkA61knP5i5NLPuIy4cybBBv9lnd24LVR9sfi9Tss96VQdsGCQhq1";
      };
      "root" = {
        uid = 0;
        home = "/root";
        initialHashedPassword = "$6$KV00qSRKyx1hpZjX$kwzWN4UuQxHSFwA4vYtRTcYecQyR.Qelvvcr90ZfZ4y.LISUcx2PDHH9/7REwsoAHD./KlAnwlsm1hxeLoGpl/";
      };
    };
  };
  boot = {
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      includeDefaultModules = false;
    };
  };
}
