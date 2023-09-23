{
  lib,
  runCommandNoCC,
  makeBinaryWrapper,
  fetchurl,
  jre,
}: let
  pname = "papermc";
  version = "1.20.1.83";
in
  runCommandNoCC "papermc" {
    inherit pname version;

    src = let
      mcVersion = lib.versions.pad 3 version;
      buildNum = builtins.elemAt (lib.versions.splitVersion version) 3;
    in
      fetchurl {
        url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
        hash = "sha256-HQpc3MOXa1wkXqgm9ciQj04FUIyuupnYiu+2RZ/sXE4=";
      };

    nativeBuildInputs = [makeBinaryWrapper];

    meta = {
      description = "High-performance Minecraft Server";
      homepage = "https://papermc.io/";
      sourceProvenance = with lib.sourceTypes; [binaryBytecode];
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [aaronjanse neonfuz];
      mainProgram = "minecraft-server";
    };
  }
  ''
    install -D $src $out/share/papermc/papermc.jar
    makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/papermc/papermc.jar nogui"

  ''
