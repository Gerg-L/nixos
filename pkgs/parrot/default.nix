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
rustPlatform.buildRustPackage {
  pname = "parrot";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "6b1df01bd9cce1c0d8446dea720c4a32ff935514";
    hash = "sha256-f6YAdsq2ecsOCvk+A8wsUu+ywQnW//gCAkVLF0HTn8c=";
  };

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
  cargoSha256 = "sha256-RueYf+SzDwhqEb40iR0hViEuMinH72T480fuqJWJ+uk=";

  RUSTC_BOOTSTRAP = 1;
}
