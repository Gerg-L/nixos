_:
{
  lib,
  pkgs,
  config,
  ...
}:
{
  local = {
    remoteBuild.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
      loginUser = "media";
    };
    DE.xfce.enable = true;
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      neovim
      vlc
      pavucontrol # gui volume control
      chromium
    ;
  };
  services.xserver.videoDrivers = [ "intel" ];

  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  sops.secrets.root.neededForUsers = true;

  users = {
    mutableUsers = false;
    users = {
      media = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "audio"
        ];
        initialHashedPassword = "";
      };
      "root" = {
        uid = 0;
        home = "/root";
        openssh.authorizedKeys.keys = [
          config.local.keys.gerg_gerg-phone
          config.local.keys.gerg_gerg-windows
          config.local.keys.gerg_gerg-desktop
        ];
        hashedPasswordFile = config.sops.secrets.root.path;
      };
    };
  };
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  boot = {
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
    "L+ %h/Desktop/chromium-browser.desktop - - - - ${pkgs.chromium}/share/applications/chromium-browser.desktop"
    "L+ %h/Desktop/vlc.desktop - - - - ${pkgs.vlc}/share/applications/vlc.desktop"
  ];

  system.stateVersion = "23.05";

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];
  _file = ./main.nix;
}
