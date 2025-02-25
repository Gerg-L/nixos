{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  zulu17,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lavalink";
  version = "4.0.8";

  src = fetchurl {
    url = "https://github.com/lavalink-devs/Lavalink/releases/download/${finalAttrs.version}/Lavalink.jar";
    hash = "sha256-G4a9ltPq/L0vcazTQjStTlOOtwrBi37bYUNQHy5CV9Y=";
  };

  plugin = fetchurl {
    url = "https://github.com/lavalink-devs/youtube-source/releases/download/1.11.5/youtube-plugin-1.11.5.jar";
    hash = "sha256-Zz4S5mWcsVFWGmN41L34GqZeCOswt/CAn+1PN1XJtbk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildCommand = ''
    install -Dm644 "$src" "$out/lib/Lavalink.jar"
    install -Dm644 "$plugin" "$out/plugins/youtube-plugin.jar"

    mkdir -p $out/bin
    makeWrapper ${lib.getExe zulu17} $out/bin/lavalink \
      --add-flags "-jar -Xmx4G $out/lib/Lavalink.jar"
  '';

  meta.mainProgram = "lavalink";

})
