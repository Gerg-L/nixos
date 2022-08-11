{ config, pkgs, lib, ... }:
{
  system.stateVersion = "22.11";
  environment = {
    defaultPackages = [];
    binsh = "${pkgs.dash}/bin/dash";
    variables = {
      EDITOR = "nvim";
    };
  };
  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  networking = {
    firewall.enable = true;
    firewall.allowPing = true;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };
  qt5 = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
  programs.dconf.enable = true;
  time.timeZone = "America/New_York";
  services = {
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

  #enable ssh
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.openssh.enable = true;
}
