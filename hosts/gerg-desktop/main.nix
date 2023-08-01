{nvim-flake, ...}: {
  pkgs,
  config,
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
      lint = pkgs.writeShellScriptBin "lint" ''
        deadnix -e "''${1:-.}"
        statix fix -- "''${1:-.}"
        alejandra "''${1:-.}"
      '';
    };
    etc = {
      "jdks/17".source = "${pkgs.openjdk17}/bin";
      "jdks/8".source = "${pkgs.openjdk8}/bin";
    };
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;

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
        bridge = ["br0"];
        linkConfig.RequiredForOnline = "enslaved";
      };
      "br0" = {
        name = "br0";
        address = [
          "192.168.1.4/24"
        ];
        gateway = [
          "192.168.1.1"
        ];
        dns = [
          "192.168.1.1"
        ];
        DHCP = "no";
        bridgeConfig = {};
        linkConfig = {
          MACAddress = "D8:5E:D3:E5:47:90";
          RequiredForOnline = "routable";
        };
      };
    };
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
      systemd.enable = true;
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      includeDefaultModules = false;
    };
  };

  system.stateVersion = "23.05";
  _file = ./main.nix;
}
