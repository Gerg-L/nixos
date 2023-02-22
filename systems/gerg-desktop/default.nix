inputs: {
  pkgs,
  settings,
  ...
}: {
  imports = [
    (import ./refreshrate.nix inputs)
    (import ./vfio.nix inputs)
    (import ./parrot.nix inputs)
    (import ./spicetify.nix inputs)
    #(import ./mining.nix inputs)
    (import ./zfs inputs)

    (import ../../imports/fonts.nix inputs)
    (import ../../imports/git.nix inputs)
    (import ../../imports/shells.nix inputs)
    (import ../../imports/theme.nix inputs)
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
  ];
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
  users.users."${settings.username}" = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "audio"];
  };
  boot = {
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      includeDefaultModules = false;
    };
  };
}
