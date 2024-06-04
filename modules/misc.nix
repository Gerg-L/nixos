{ _file }:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.local.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    nixpkgs = {
      config = {
        allowAliases = false;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.local.allowedUnfree;
      };
    };

    programs.git.enable = true;
    # Mr sandro why
    services.libinput.enable = true;
    programs.nano.enable = false;

    environment.defaultPackages = lib.mkForce (
      builtins.attrValues {
        inherit (pkgs)
          bottom # view tasks
          efibootmgr # efi editor
          nix-output-monitor # nom nom nom nom;
          nix-tree # view packages
          pciutils # lspci
          nix-janitor # thanks nobbz
          ;
      }
    );

    #enable ssh
    programs.mtr.enable = true; # ping and traceroute
    services.openssh = {
      enable = true;
      hostKeys = lib.mkForce [ ];
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    programs.ssh = {
      startAgent = true;
      agentTimeout = "1m";
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    i18n.defaultLocale = "en_US.UTF-8";
    #time settings

    time.timeZone = "America/New_York";

    # For `info` command.
    documentation.info.enable = false;
    # NixOS manual and such.
    documentation.nixos.enable = false;
    # Useless with flakes (without configuring)
    programs.command-not-found.enable = false;
  };
  inherit _file;
}
