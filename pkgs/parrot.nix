{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cmake,
  libopus,
  yt-dlp,
  ffmpeg,
  makeWrapper,
}:
# yt-dlp and ffmpeg required at runtime
let
  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "6b1df01bd9cce1c0d8446dea720c4a32ff935514";
    hash = "sha256-f6YAdsq2ecsOCvk+A8wsUu+ywQnW//gCAkVLF0HTn8c=";
  };
in
  rustPlatform.buildRustPackage
  {
    pname = "parrot";
    version = "1.6.0";
    inherit src;
    buildInputs = [
      libopus
      openssl
    ];

    nativeBuildInputs = [
      pkg-config
      cmake
      makeWrapper
    ];
    postInstall = ''
      wrapProgram $out/bin/parrot \
        --set PATH ${lib.makeBinPath [
        yt-dlp
        ffmpeg
      ]}'';

    cargoLock.lockFile = src + /Cargo.lock;

    RUSTC_BOOTSTRAP = 1;
  }
