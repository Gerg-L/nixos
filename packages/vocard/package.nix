{
  lib,
  fetchFromGitHub,
  python3,
  stdenv,
  makeBinaryWrapper,
}:
let
  version = "2.7.1";
  python = python3.withPackages (p: [
    p.discordpy
    p.motor
    p.dnspython
    p.tldextract
    p.validators
    p.humanize
    p.beautifulsoup4
    p.psutil
  ]);
in
stdenv.mkDerivation {
  pname = "vocard";
  inherit version;

  src = fetchFromGitHub {
    owner = "ChocoMeow";
    repo = "Vocard";
    tag = "v${version}";
    hash = "sha256-0cSR9z6JNB0xdHMyDrDRJQ7xilqGVifCowXuNKipgjQ=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/lib
    cp -r . $out/lib

    runHook postBuild
  '';

  patches = [ ./useLoadCredential.patch ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper '${python.interpreter}' "$out/bin/vocard" \
      --add-flags "-u ${placeholder "out"}/lib/main.py"

    runHook postInstall
  '';

  meta = {
    description = "Vocard is a simple music bot. It leads to a comfortable experience which is user-friendly, It supports Youtube, Soundcloud, Spotify, Twitch and more";
    homepage = " https://github.com/ChocoMeow/Vocard";
    license = lib.licenses.mit;
    mainProgram = "vocard";
    platforms = lib.platforms.all;
  };
}
