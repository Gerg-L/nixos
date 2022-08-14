{ lib
, stdenv
, writeText
, fetchFromGitHub
, xorg
}:
let

in
stdenv.mkDerivation rec {
  pname = "AFKCommands";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ISnortPennies";
    repo = "AFKCommands";
    rev = version;
    sha256 = "sha256-5K7f/GU15nmzvw65p5Nk4f/8hafl9GNHfmAmpCZctQA=";
  };

  buildInputs = [
    xorg.libXScrnSaver
    xorg.libX11
  ];
  
  ConfigText = writeText "config.h" ''
    const int AFK = 10;
    const int RESTART = 60;
    const char* COMMANDS[] = {
     "echo \"config worked\"",
     "echo \"sample command 2\"",
    };
  '';
  configurePhase = ''
  mkdir -p $out/bin
  export C_INCLUDE_PATH=$out
  cp $ConfigText $out/config.h
   '';
  buildPhase = ''
  gcc AFKCommands.c -o AFKCommands -Wall -Wextra -Werror -lXss -lX11
  '';
  installPhase = ''
  mv AFKCommands $out/bin/AFKCommands
  '';
  meta = with lib; {
    homepage = "https://github.com/ISnortPennies/AFKCommands";
    description = "A utility that queries the X server for the user's idle time and prints it to stdout";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
