{
  lib,
  pkgs,
  config,
  nvim-flake,
}:
{
  local = {
    remoteBuild.enable = true;
    DM.lightdm.enable = true;
    DE.xfce.enable = true;
    theming = {
      enable = true;
      kmscon.enable = true;
    };
    packages = {
      inherit (pkgs)
        mpv
        pwvucontrol # gui volume control
        librewolf
        ;
      inherit (nvim-flake.packages) neovim;
    };
  };

  services = {
    xserver.videoDrivers = [ "modesetting" ];
    displayManager.autoLogin = {
      enable = true;
      user = "media";
    };
    openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  };

  networking = {
    networkmanager.enable = true;
    hostName = "media-laptop";
  };

  sops.secrets.root.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      media = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = [ "networkmanager" ];
        initialHashedPassword = "";
      };
      root = {
        openssh.authorizedKeys.keys = builtins.attrValues {
          inherit (config.local.keys) gerg_gerg-phone gerg_gerg-windows gerg_gerg-desktop;
        };
        hashedPasswordFile = config.sops.secrets.root.path;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "xhci-pci"
      "ehci-pci"
      "ahci"
      "usbhid"
      "sd_mod"
      "sr_mod"
      "rtsx_usb_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  systemd.user.tmpfiles.users.media.rules = [
    "L+ %h/Desktop/librewolf.desktop - - - - ${pkgs.librewolf}/share/applications/librewolf.desktop"
  ];

  # Reformat at some point
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
