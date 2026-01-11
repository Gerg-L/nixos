{
  environment.shellAliases = {
    sudo = "sudo ";
    #make run0 use aliases
    run0 = "run0 --background='' ";
    s = "run0";
  };
  security = {
    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults timestamp_timeout=1
        Defaults env_keep += "EDITOR VISUAL PAGER SYSTEMD_PAGERSECURE MANPAGER"
        Defaults lecture = never
      '';
    };
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (
              action.id == "org.freedesktop.systemd1.run" &&
              subject.isInGroup("wheel")
          ) {
              return polkit.Result.AUTH_KEEP;
          }
      });
    '';
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };
  environment.etc."polkit-1/localauthority/50-local.d/99-custom.pkla".text = ''
    [Authorization]
    DefaultTimeoutStartSec=60
  '';
}
