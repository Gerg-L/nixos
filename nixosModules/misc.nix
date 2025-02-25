{
  lib,
  config,
  pkgs,
  nix-janitor,
}:
{

  nixpkgs.config.allowAliases = false;
  local.packages = {
    inherit (pkgs)
      bottom # view tasks
      efibootmgr # efi editor
      nix-output-monitor # nom nom nom nom;
      nix-tree # view packages
      pciutils # lspci
      ;
    nix-janitor = pkgs.symlinkJoin {
      name = "nix-janitor";
      paths = [ nix-janitor.packages.default ];
      nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/janitor" \
        --suffix PATH : ${lib.makeBinPath [ config.nix.package ]}
      '';
    };
    nixos-rebuild-ng = pkgs.symlinkJoin {
      name = "nixos-rebuild-ng";
      paths = [ pkgs.nixos-rebuild-ng ];
      postBuild = ''
        ln -s "$out/bin/nixos-rebuild-ng" "$out/bin/nixos-rebuild"
      '';
    };

  };

  programs.git.enable = true;
  # Mr sandro why
  services.libinput.enable = true;
  programs.nano.enable = false;
  programs.less.enable = lib.mkForce false;

  environment.defaultPackages = lib.mkForce [ ];

  #enable ssh
  programs.mtr.enable = true; # ping and traceroute
  services.openssh = {
    enable = true;
    hostKeys = lib.mkForce [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PermitRootLogin = lib.mkOverride 1001 "no";
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

  system.disableInstallerTools = true;

  services.userborn.enable = true;
  boot.enableContainers = false;

}
