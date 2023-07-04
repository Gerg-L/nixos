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
rustPlatform.buildRustPackage
{
  pname = "parrot";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "6b1df01bd9cce1c0d8446dea720c4a32ff935514";
    hash = "sha256-f6YAdsq2ecsOCvk+A8wsUu+ywQnW//gCAkVLF0HTn8c=";
  };

  cargoHash = "sha256-e4NHgwoNkZ0//rugHrP0gU3pntaMeBJsV/YSzJfD8r4=";

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    libopus
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/parrot \
      --prefix PATH : ${lib.makeBinPath [
      yt-dlp
      ffmpeg
    ]}
  '';
}
