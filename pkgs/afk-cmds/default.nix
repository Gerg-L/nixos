{ lib
, rustPlatform
, fetchFromGitHub
, xorg
}:
rustPlatform.buildRustPackage rec {
  pname = "afk-cmds";
  version= "1.0.0";

  src = fetchFromGitHub {
    owner = "ISnortPennies";
    repo = "afk-cmds";
    rev = "6a131c4892ea411281426d1165a48607e556f729";
    sha256 = "sha256-LK6XeQc5Rc7KxwL2r2L3dCAKtbENuigbyTTuS+7JKnQ=";
  };

  buildInputs = [
    xorg.libXScrnSaver
    xorg.libX11
  ];
  
  cargoSha256 = "sha256-Osxg/KuHOdnz8UYnbT69dmNFLHW6Cq1fLb32/UJeDUg=";

  meta = with lib; {
    homepage = "https://github.com/ISnortPennies/AFKCommands";
    description = "";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

