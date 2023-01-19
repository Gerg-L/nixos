{ lib
, rustPlatform
, fetchFromGitHub
, yt-dlp
, pkg-config
, openssl
, cmake
}:
rustPlatform.buildRustPackage rec {
  pname = "parrot";
  version = "1.4.2";
  # buildFeatures = ["let_else"];
  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "28d7db3c5b50c7ba01eec71a3177875feae44bcc";
    sha256 = "sha256-G9SfaiR/KIt+Xm7vLs/EGaImZeSaUbpgAArfK6oVJeM=";
  };

  buildInputs = [
    yt-dlp
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  cargoSha256 = "sha256-ScwyPTq9da0hst/b2FX89SP03OX3HrJT3oUKGsHEjgs=";

  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    homepage = "https://github.com/aquelemiguel/parrot";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };

}
