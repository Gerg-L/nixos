{
  lib,
  nix-index-database,
  nvim-flake,
  self',
  pkgs,
  config,
}:
{
  local = {
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
      "nvidia-settings"
      "steam"
      "steam-unwrapped"
      "steam-run"
    ];
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaPersistenced = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    open = true;
    powerManagement = {
      enable = lib.mkForce false;
      finegrained = lib.mkForce false;
    };
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:15:0:0";
      #sync.enable = true;
    };
  };
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

  hardware.amdgpu = {
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
    initrd.enable = true;
    opencl.enable = true;
  };

  programs = {
    steam.enable = true;

    direnv = {
      enable = true;
      loadInNixShell = false;
      silent = true;
    };

    nix-index = {
      enable = true;
      package = nix-index-database.packages.nix-index-with-db;
    };

    adb.enable = true;
  };

  nix = {
    settings.system-features = [
      "kvm"
      "big-parallel"
      "nixos-test"
      "benchmark"
    ];
    extraOptions = ''
      !include ${config.sops.secrets.github_token.path}
    '';
  };
  sops.secrets.github_token = { };

  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        bitwarden-desktop # store stuff
        qbittorrent # steal stuff
        pavucontrol # gui volume control
        pcmanfm # file manager
        vlc # play stuff
        ripgrep
        fd
        jq
        wget
        xautoclick
        prismlauncher
        deadnix
        statix
        #element-desktop
        vesktop
        gh
        nixfmt-rfc-style
        prusa-slicer # 3D printer slicer
        # QMK configuration
        #via
        #qmk

        ;
      inherit (nvim-flake.packages) neovim;
      inherit (self'.packages) lint;

      librewolf = pkgs.librewolf.override { cfg.speechSynthesisSupport = false; };
      nixpkgs-review = pkgs.nixpkgs-review.override { nix = config.nix.package; };
    };
    etc = {
      "jdks/17".source = "${pkgs.openjdk17}/bin";
      "jdks/8".source = "${pkgs.openjdk8}/bin";
    };
  };

  services.udev.packages = [
    pkgs.android-udev-rules
    # pkgs.via
    # pkgs.qmk-udev-rules
  ];

  networking = {
    useNetworkd = false;
    useDHCP = false;
    hostId = "288b56db";
    firewall.enable = true;
  };

  systemd.network = {
    enable = true;
    netdevs."br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };
    networks = {
      "enp11s0" = {
        name = "enp11s0";
        bridge = [ "br0" ];
        linkConfig.RequiredForOnline = "enslaved";
      };
      "br0" = {
        name = "br0";
        address = [ "192.168.1.4/24" ];
        gateway = [ "192.168.1.1" ];
        dns = [ "192.168.1.1" ];
        DHCP = "no";
        bridgeConfig = { };
        linkConfig = {
          MACAddress = "D8:5E:D3:E5:47:90";
          RequiredForOnline = "routable";
        };
      };
    };
  };

  #user managment
  sops.secrets.gerg.neededForUsers = true;

  users = {
    mutableUsers = false;
    users = {
      gerg = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "adbusers"
          "plugdev"
        ];
        openssh.authorizedKeys.keys = builtins.attrValues {
          inherit (config.local.keys) gerg_gerg-phone gerg_gerg-windows;
        };
        hashedPasswordFile = config.sops.secrets.gerg.path;
      };
      root.hashedPassword = "!";
    };
  };
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ];
    includeDefaultModules = false;
  };

  system.stateVersion = "24.11";
  networking.hostName = "gerg-desktop";
  nixpkgs.hostPlatform = "x86_64-linux";
}
