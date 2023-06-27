{nvim-flake, ...}: {
  pkgs,
  config,
  ...
}: {
  localModules = {
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

  nixpkgs.allowedUnfree = [
    "nvidia-x11"
    "steam"
    "steam-original"
  ];

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
        ;
      inherit (nvim-flake.packages.${pkgs.system}) neovim;
    };
    etc = {
      "jdks/17".source = "${pkgs.openjdk17}/bin";
      "jdks/8".source = "${pkgs.openjdk8}/bin";
    };
  };

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
