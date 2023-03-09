_: {lib, ...}: {
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
