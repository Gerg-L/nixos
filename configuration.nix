{ config, pkgs, callPackage, lib, ... }:
{
  #important stuff first
  imports =
    [
      ./boot.nix
      ./prime.nix
      ./networking.nix
      ./packages.nix
      ./fonts.nix
      ./thunar.nix
    ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.xserver = import ./xserver.nix;
  fileSystems = import ./fileSystems.nix;
  system.stateVersion = "22.11";
  hardware.cpu.amd.updateMicrocode = true;  
  # end important stuff
  qt5 = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };
  time.timeZone = "America/New_York";
  services = {
    gvfs.enable = true;
    timesyncd = {
      enable = true;
      servers = [
        "time.google.com"
        "time2.google.com"
      ];
    };
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable sound.
  security.rtkit.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
   nixpkgs.config.pulseaudio = true;
  # user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users.gerg = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "networkmanager"];
    };
  };

  #enable ssh
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    };
  services.openssh.enable = true;
}

