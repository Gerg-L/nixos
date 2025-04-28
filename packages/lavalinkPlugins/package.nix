{
  fetchurl,
  linkFarm,
}:
linkFarm "lavalinkPlugins" [
  {
    name = "youtube-plugin-1.13.0.jar";
    path = fetchurl {
      url = "https://github.com/lavalink-devs/youtube-source/releases/download/1.13.0/youtube-plugin-1.13.0.jar";
      hash = "sha256-DL5s+a7HJel9Ouh9tJwFmCN25ThmIJNUhmQ7pn+moCg=";
    };
  }
]
