{
  pkgs,
  config,
  ...
}: {
  localModules = {
    remoteBuild.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
      loginUser = "jo";
    };
    DE.xfce.enable = true;
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      neovim
      vlc
      nomacs
      rsync
      pavucontrol #gui volume control
      librewolf #best browser
      ;
  };
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
      jo = {
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
  systemd.tmpfiles.rules = [
    "L+ /home/jo/Desktop/gimp.desktop - - - - ${pkgs.gimp}/share/applications/gimp.desktop"
    "L+ /home/jo/Desktop/org.gnome.Calculator.desktop - - - - ${pkgs.gnome.gnome-calculator}/share/applications/org.gnome.Calculator.desktop"
    "L+ /home/jo/Desktop/org.nomacs.ImageLounge.desktop - - - - ${pkgs.nomacs}/share/applications/org.nomacs.ImageLounge.desktop"
    "L+ /home/jo/Desktop/thunar.desktop - - - - ${pkgs.xfce.thunar}/share/applications/thunar.desktop"
    "L+ /home/jo/Desktop/librewolf.desktop - - - - ${pkgs.librewolf}/share/applications/librewolf.desktop"
    "L+ /home/jo/Desktop/vlc.desktop - - - - ${pkgs.vlc}/share/applications/vlc.desktop"
    "L /home/jo/Desktop/Downloads - - - - /home/jo/Downloads"
    "L /home/jo/Desktop/Documents - - - - /home/jo/Documents"
    "L /home/jo/Desktop/Pictures - - - - /home/jo/Pictures"
  ];

  system.stateVersion = "23.05";
}
