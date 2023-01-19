{ config, pkgs, lib, ... }:
{
  system.stateVersion = "23.05";
  environment = {
    defaultPackages = [];
    binsh = "${pkgs.dash}/bin/dash";
    variables = {
      EDITOR = "nvim";
    };
  };
  # boot faster
  systemd.services.NetworkManager-wait-online.enable = false;
  nix = {
    settings = {
      auto-optimise-store = true;
      cores = 0;
    };
    extraOptions = ''
      keep-outputs = false
      keep-derivations = false
      experimental-features = nix-command flakes
      '';
  };
  networking = {
    firewall.enable = true;
    firewall.allowPing = true;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };
  services.gvfs.enable = true;
  qt = {
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
#should be false
  sound.enable = false;

# rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
