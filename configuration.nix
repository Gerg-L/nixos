{ config, pkgs, lib, ... }:
{

  system.stateVersion = "23.05";
  environment = {
    defaultPackages = [ ]; #don't install anything by default
    binsh = "${pkgs.dash}/bin/dash"; #use dash for speed
    variables = {
      EDITOR = "vi";
      VISUAL = "vi";
    };
  };
  #nix stuff
  nix = {
    settings = {
      auto-optimise-store = true; #save space
      cores = 0; # use all cores
      keep-outputs = false; #don't make ./results files
      keep-derivations = false; #^
      experimental-features = "nix-command flakes";
    };
  };
  #sound settings
  security.rtkit.enable = true;
  sound.enable = false; #disable alsa
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
    };
    networkmanager.enable = true;
  };
  #enable ssh
  programs = {
    mtr.enable = true; #ping and traceroute
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };


  #themeing
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };

  #time settings
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
  #terminal stuff
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  programs.dconf.enable = true;
  services.gvfs.enable = true; #gvfs for pcmanfm
}
