_:
{
  pkgs,
  config,
  lib,
  ...
}:
{
  local = {
    remoteBuild.enable = true;
    DE.gnome.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
      loginUser = "games";
    };
    theming = {
      enable = true;
      kmscon.enable = true;
    };
    allowedUnfree = [
      "nvidia-x11"
      "nvidia-persistenced"
      "steam"
      "steam-run"
      "steam-original"
    ];
  };
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        neovim
        heroic
        legendary-gl
        prismlauncher
        pcmanfm # file manager
        librewolf # best browser
        obs-studio
        vlc
        webcord
        blender
        unzip
        ;

      inherit (pkgs.wineWowPackages) unstableFull;
      inherit (pkgs.libsForQt5) kdenlive;
    };
    etc = {
      "jdks/17".source = "${pkgs.openjdk17}/bin";
      "jdks/8".source = "${pkgs.openjdk8}/bin";
    };
  };

  programs.steam.enable = true;

  networking.networkmanager.enable = true;

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  #user managment
  sops.secrets.root.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      games = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["audio"];
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

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    nvidiaPersistenced = true;
    nvidiaSettings = false;
    modesetting.enable = true;
  };
  services.xserver = {
    videoDrivers = ["nvidia"];
    #disable DPMS
    monitorSection = ''
      Option "DPMS" "false"
    '';
    #disable screen blanking in total
    serverFlagsSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "BlankTime" "0"
    '';
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
    ];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "23.05";
  #_file
}
