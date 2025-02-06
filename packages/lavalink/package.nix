{
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre_headless,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lavalink";
  version = "4.0.8";

  src = fetchurl {
    url = "https://github.com/lavalink-devs/Lavalink/releases/download/${finalAttrs.version}/Lavalink.jar";
    hash = "sha256-G4a9ltPq/L0vcazTQjStTlOOtwrBi37bYUNQHy5CV9Y=";
  };

  plugin = fetchurl {
    url = "https://github.com/lavalink-devs/youtube-source/releases/download/1.11.4/youtube-plugin-1.11.4.jar";
    hash = "sha256-OznpsYoiWa6y+/8kukWN66leLi2mZU/1x+zN+uyIk1k=";
  };


  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildCommand = ''
    install -Dm644 "$src" "$out/lib/Lavalink.jar"
    install -Dm644 "$plugin" "$out/plugins/youtube-plugin.jar"

    mkdir -p $out/bin
    makeWrapper ${jre_headless}/bin/java $out/bin/lavalink \
      --add-flags "-jar -Xmx4G $out/lib/Lavalink.jar"
  '';

  meta.mainProgram = "lavalink";

})
