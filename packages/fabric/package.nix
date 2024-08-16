{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre,
}:
stdenvNoCC.mkDerivation {
  name = "fabric";

  src = fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.16.2/1.0.1/server/jar";
    hash = "sha256-1Qk7qDdC70lkeduCyzhPcKfoSrcCmTbVD1Yi9lEDjEk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/papermc/papermc.jar

    makeWrapper ${lib.getExe jre} "$out/bin/fabric" \
      --append-flags "-jar $out/share/papermc/papermc.jar nogui"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  meta.mainProgram = "fabric";
}
