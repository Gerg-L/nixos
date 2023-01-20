{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
, libopus
}:
# yt-dlp and ffmpeg required at runtime

rustPlatform.buildRustPackage rec {
  pname = "parrot";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "b2c5ad7774616f488e9fc556082da545c5461c21";
    sha256 = "sha256-S73Ef4GjdHjkiQZnOqwFzuidWnSrMe92rc1qZ6rYdiY=";
  };

  buildInputs = [
    libopus
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  cargoSha256 = "sha256-qPyuj5OxHrWz0YbrquCTTKZM3j1poXuioNNvn9z+xDQ=";

  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    homepage = "https://github.com/aquelemiguel/parrot";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };

}
