{
  config,
  pkgs,
  _dir,
}:
{
  sops.secrets.cloudflare = { };

  systemd.services.ddns = {
    reloadIfChanged = false;
    restartIfChanged = false;
    stopIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    startAt = "*:0/30";

    serviceConfig = {
      EnvironmentFile = config.sops.secrets.cloudflare.path;
      DynamicUser = true;
    };

    path = [
      pkgs.netcat
      pkgs.jq
      pkgs.curl
    ];

    script = builtins.readFile "${_dir}/ddns_script.sh";
  };
}
