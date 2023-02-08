{
  pkgs,
  settings,
  ...
}: {
  boot = {
    kernelModules = ["msr"];
    kernelParams = ["iomem=relaxed" "msr.allow_writes=on"];
  };
  systemd.services.mining = {
    enable = true;
    path = with pkgs; [t-rex-miner afk-cmds st zsh dbus xmrig];
    wantedBy = ["multi-user.target"];
    wants = ["graphical.target"];
    script = ''
      afk-cmds -c /home/${settings.username}/afk-cmds.json
    '';
    environment = {
      #  PATH="/run/current-system/sw/bin"; missing something with dbus
      XAUTHORITY = "/home/${settings.username}/.Xauthority";
      DISPLAY = ":0";
      XDG_DATA_DIRS = "/nix/var/nix/profiles/default/share:/run/current-system/sw/share";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
      NO_AT_BRIDGE = "1";
    };
  };
}
