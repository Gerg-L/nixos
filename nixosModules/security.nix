{
  environment.shellAliases = {
    #make run0 use aliases
    run0 = "run0 --background='' ";
    s = "run0";
  };
  services.dbus.implementation = "broker";
  security = {
    sudo.enable = false;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.policykit.exec") {
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });

        polkit.addRule(function(action, subject) {
          if (action.id.indexOf("org.freedesktop.systemd1.") == 0) {
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
  };
  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=60
  '';
}
