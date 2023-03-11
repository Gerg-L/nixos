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
  i18n.defaultLocale = "en_US.UTF-8";
}
