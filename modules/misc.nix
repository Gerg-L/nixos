_: {
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    dummyvalue = lib.mkOption {
      default = {};
      type = lib.configType;
    };
    nixpkgs.allowedUnfree = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [];
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.nixpkgs.allowedUnfree != []) {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfree;
    })
    {
      environment.defaultPackages = lib.mkForce [
        pkgs.efibootmgr #efi editor
        pkgs.pciutils #lspci
        pkgs.alsa-utils #volume control
        pkgs.xclip #commandline clipboard access
        pkgs.bottom #view tasks
        pkgs.nix-tree #view packages
        pkgs.nix-output-monitor #nom nom nom nom];
      ];

      #enable ssh
      programs.mtr.enable = true; #ping and traceroute
      services.openssh = {
        enable = true;
        hostKeys = lib.mkForce [];
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
      i18n.defaultLocale = "en_US.UTF-8";
      #time settings
      time.timeZone = "America/New_York";
    }
  ];
}
