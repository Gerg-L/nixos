{
  fetchurl,
  linkFarm,
}:
linkFarm "lavalinkPlugins" [
  {
    name = "youtube-plugin-1.12.0.jar";
    path = fetchurl {
      url = "https://github.com/lavalink-devs/youtube-source/releases/download/1.12.0/youtube-plugin-1.12.0.jar";
      hash = "sha256-M9CDMDGR7fBldPLLG/I5TN21DLNN440nzF1l34MrQK0=";
    };
  }
]
