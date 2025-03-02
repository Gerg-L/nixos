{
  fetchurl,
  linkFarm,
}:
linkFarm "lavalinkPlugins" [
  {
    name = "youtube-plugin-1.11.5.jar";
    path = fetchurl {
      url = "https://github.com/lavalink-devs/youtube-source/releases/download/1.11.5/youtube-plugin-1.11.5.jar";
      hash = "sha256-Zz4S5mWcsVFWGmN41L34GqZeCOswt/CAn+1PN1XJtbk=";
    };
  }
]
