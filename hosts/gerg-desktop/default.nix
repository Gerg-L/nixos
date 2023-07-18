{nvim-flake, ...}: {
  pkgs,
  config,
  lib,
  ...
}: {
  local = {
    remoteBuild.isBuilder = true;
    X11Programs = {
      sxhkd.enable = true;
    };
    DE.dwm.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
      loginUser = "gerg";
    };
    theming = {
      enable = true;
      kmscon.enable = true;
    };
    allowedUnfree = [
      "nvidia-x11"
    ];
  };
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaPersistenced = false;
    nvidiaSettings = false;
    modesetting.enable = true;
    open = false;
  };
  services.xserver = {
    videoDrivers = ["nvidia" "amdgpu"];
  };

  programs.direnv = {
    enable = true;
    loadInNixShell = false;
    silent = true;
  };

  nix.settings.system-features = ["kvm" "big-parallel" "nixos-test" "benchmark"];

  environment = {
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        bitwarden #store stuff
        qbittorrent #steal stuff
        pavucontrol #gui volume control
        pcmanfm #file manager
        librewolf #best browser
        vlc #play stuff
        ripgrep
        xautoclick
        webcord
        prismlauncher
        deadnix
        statix
        alejandra
        nix-index
        ;
      inherit (nvim-flake.packages.${pkgs.system}) neovim;
    };
    etc = {
      "jdks/17".source = lib.getBin pkgs.openjdk17;
      "jdks/8".source = lib.getBin pkgs.openjdk8;
    };
    shellAliases.lint = "deadnix -e && statix fix && alejandra ./";
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;

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
      };
    };
    bridges."bridge0".interfaces = ["eth0"];
    firewall.enable = true;
  };
  #user managment
  sops.secrets = {
    gerg.neededForUsers = true;
  };
  users = {
    mutableUsers = false;
    users = {
      gerg = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["wheel" "audio" "adbusers"];
        openssh.authorizedKeys.keys = [
          config.local.keys.gerg_gerg-phone
          config.local.keys.gerg_gerg-windows
        ];
        passwordFile = config.sops.secrets.gerg.path;
      };
      "root" = {
        uid = 0;
        home = "/root";
        hashedPassword = "!";
      };
    };
  };
  boot = {
    kernelModules = ["amdgpu"];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      includeDefaultModules = false;
    };
  };

  system.stateVersion = "23.05";
}
