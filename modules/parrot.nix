{
  pkgs,
  settings,
  ...
}: {
  #discord bot stuff
  virtualisation.docker.enable = false;
  systemd.services.parrot = {
    enable = true;
    path = with pkgs; [parrot yt-dlp ffmpeg];
    wantedBy = ["multi-user.target"];
    wants = ["NetworkManager-wait-online.service"];
    after = ["NetworkManager-wait-online.service"];
    script = "parrot";
    serviceConfig = {
      EnvironmentFile = "/home/${settings.username}/parrot/.env";
    };
  };
}
