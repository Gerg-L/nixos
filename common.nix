_: {
  lib,
  pkgs,
  ...
}: {
  #use a better tty
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-size=10
    '';
    fonts = [
      {
        name = "Overpass Mono";
        package = pkgs.overpass;
      }
      {
        name = "OverpassMono Nerd Font";
        package =
          pkgs.nerdfonts.override
          {
            fonts = ["Overpass"];
          };
      }
      {
        name = "Material Design Icons";
        package = pkgs.material-design-icons;
      }
    ];
  };
  systemd.services = {
    "autovt@tty1".enable = false;
    "kmsconvt@tty1".enable = false;
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
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  #time settings
  time.timeZone = "America/New_York";
  services = {
    timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com"
      ];
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
}
