{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  zulu17,
  udev,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lavalink";
  version = "4.0.8";

  src = fetchurl {
    url = "https://github.com/lavalink-devs/Lavalink/releases/download/${finalAttrs.version}/Lavalink.jar";
    hash = "sha256-G4a9ltPq/L0vcazTQjStTlOOtwrBi37bYUNQHy5CV9Y=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildCommand = ''
    install -Dm644 "$src" "$out/lib/Lavalink.jar"

    mkdir -p "$out/bin"
    makeWrapper '${lib.getExe zulu17}' "$out/bin/lavalink" \
      --add-flags "-jar $out/lib/Lavalink.jar" \
      --set 'LD_LIBRARY_PATH' '${lib.makeLibraryPath [ udev ]}'
  '';

  meta.mainProgram = "lavalink";
})
