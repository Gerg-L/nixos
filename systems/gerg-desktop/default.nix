inputs: {
  pkgs,
  settings,
  self,
  config,
  ...
}: {
  imports = [
    (import ./refreshrate.nix inputs)
    (import ./vfio.nix inputs)
    (import ./parrot.nix inputs)
    (import ./spicetify.nix inputs)
    (import ./zfs.nix inputs)
    (import ./containers inputs)
    (import ./erase-your-darlings.nix inputs)
  ];

  disko.devices = import ./disko.nix;

  system.stateVersion = "unstable";
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
    pkgs.vlc #play stuff
    pkgs.neovide #gui neovim
    pkgs.ripgrep
    inputs.suckless.packages.${pkgs.system}.st
  ];
  #set webcord theme
  systemd.tmpfiles.rules = let
    theme = pkgs.writeText "black" (builtins.readFile "${self}/misc/black.theme.css");
  in ["L+ /home/gerg/.config/WebCord/Themes/black - - - - ${theme}"];

  networking = {
    useDHCP = false;
    hostName = "gerg-desktop";
    hostId = "288b56db";
    nameservers = [
      "192.168.1.1"
      "2605:59c8:252e:500::1"
    ];
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
        ipv6.addresses = [
          {
            address = "2605:59c8:252e:500:da5e:d3ff:fee5:4790";
            prefixLength = 64;
          }
        ];
      };
    };
    bridges."bridge0".interfaces = ["eth0"];
    firewall.enable = true;
  };
  #user managment
  sops.secrets = {
    root.neededForUsers = true;
    gerg.neededForUsers = true;
  };
  users = {
    mutableUsers = false;
    users = {
      "${settings.username}" = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["wheel" "audio"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
        ];
        passwordFile = config.sops.secrets.gerg.path;
      };
      "root" = {
        uid = 0;
        home = "/root";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
        ];
        passwordFile = config.sops.secrets.root.path;
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
