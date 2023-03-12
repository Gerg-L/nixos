inputs: {
  pkgs,
  settings,
  config,
  ...
}: {
  imports = [
    (import ./printing.nix inputs)
  ];

  disko.devices = import ./disko.nix;

  localModules = {
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
    DE.xfce.enable = true;
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };

  system.stateVersion = "unstable";
  environment.systemPackages = [
    pkgs.vlc
    pkgs.nomacs
    pkgs.gnome.gnome-calculator
    pkgs.xfce.xfce4-whiskermenu-plugin
    pkgs.rsync
    pkgs.pavucontrol #gui volume control
    pkgs.librewolf #best browser
  ];
  services.xserver.videoDrivers = ["intel"];
  networking = {
    hostName = "moms-laptop";
    networkmanager.enable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  sops.secrets.root.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      "${settings.username}" = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["networkmanager" "audio"];
        initialHashedPassword = "";
      };
      "root" = {
        uid = 0;
        home = "/root";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWbwkFJmRBgyWyWU+w3ksZ+KuFw9uXJN3PwqqE7Z/i8 gerg@gerg-desktop"
        ];
        passwordFile = config.sops.secrets.root.path;
      };
    };
  };
  boot = {
    initrd.availableKernelModules = ["xhci-pci" "ehci-pci" "ahci" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
    kernelModules = ["kvm-intel"];
  };
}
