{ config, pkgs, lib, ... }:
{
  nix.settings.auto-optimise-store = true;
  networking = {
    firewall.enable = true;
    useDHCP = lib.mkDefault true;
    networkmanager. enable = true;
  };
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

  #enable ssh
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    };
  services.openssh.enable = true;
}
