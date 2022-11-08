{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "parrot";
  version= "v1.4.2";

  src = fetchFromGitHub {
    owner = aquelemiguel;
    repo = parrot;
    rev = "28d7db3c5b50c7ba01eec71a3177875feae44bcc";
    sha256 = "";

  };
  
  buildInputs = [
  ];

  nativeBuildInputs = [
  ];

  cargoSha256 = "";

  meta = with lib; {
    homepage = "https://github.com/aquelemiguel/parrot";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };

}
