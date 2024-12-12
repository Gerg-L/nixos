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
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };
}
