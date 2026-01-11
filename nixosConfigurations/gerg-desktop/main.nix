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
    DM.lightdm.enable = true;
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
      "hplip"
      "castlabs-electron"
    ];
    packages = {
      inherit (pkgs)
        bitwarden-desktop # store stuff
        pwvucontrol # gui volume control
        pcmanfm # file manager
        mpv # play stuff
        ripgrep
        fd
        jq
        wget
        xautoclick
        deadnix
        statix
        fluffychat
        vesktop
        gh
        nixfmt
        tidal-hifi
        hyperfine
        android-tools

        #prusa-slicer # 3D printer slicer
        # QMK configuration
        #via
        #qmk
        #qbittorrent # steal stuff
        ;
      inherit (nvim-flake.packages) neovim;
      inherit (self'.packages) lint;

      librewolf = pkgs.librewolf.override { cfg.speechSynthesisSupport = false; };
      nixpkgs-review = pkgs.nixpkgs-review.override { nix = config.nix.package; };
    };

    ghostty = {
      enable = true;
      defaultSettings = true;
    };

    prismlauncher.enable = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    supportedFilesystems = {
      ext4 = true;
      ntfs = true;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      includeDefaultModules = false;
    };
  };

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
  services.xserver = {
    videoDrivers = [
      "nvidia"
    ];
    displayManager.setupCommands = lib.mkBefore ''
      ${lib.getExe pkgs.xorg.xrandr} \
        --output DP-0 \
        --mode 3440x1440 \
        --rate 120 \
        --primary \
        --pos 0x0 \
        --output HDMI-0 \
        --mode 1920x1080 \
        --rate 120 \
        --pos 3440x360
    '';
    serverFlagsSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "BlankTime" "0"
    '';
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "gerg";
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
  sops.secrets.github_token.owner = "gerg";

  services.udev.packages = [
    # pkgs.via
    # pkgs.qmk-udev-rules
  ];

  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };

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

  # printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
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

  system.stateVersion = "24.11";
  networking.hostName = "gerg-desktop";
  nixpkgs.hostPlatform = "x86_64-linux";
}
