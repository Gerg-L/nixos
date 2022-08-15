{ lib
, stdenv
, writeText
, fetchFromGitHub
, xorg
}:
with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "AFKCommands";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ISnortPennies";
    repo = "AFKCommands";
    rev = "493a74886b4993c064f1ba9c12e706b046c562b6";
    sha256 = "sha256-X8mQrtXnThezLW+s8NwQQjTzc9h/tnDyqcFYFBfcyYw=";
  };

  buildInputs = [
    xorg.libXScrnSaver
    xorg.libX11
  ];
  
  ConfigText = writeText "config.h" ''
    const int AFK = 10;
    const int RESTART = 60;
    const char* COMMANDS[] = {
    "xmrig -o rx.unmineable.com:3333 -u XMR:46vHuD3G9wKVpoBV7rwQQzCRfBw3rxUo3fzj1G9mSFqPg2A71pspHsTTD2Y5hmPXFuVUXRzFj6NevVRUHriDerhw5JcNkXV.nixos",
    "steam-run /home/gerg/stuff/t-rex -a ethash -o ethash.unmineable.com:3333 -u XMR:46vHuD3G9wKVpoBV7rwQQzCRfBw3rxUo3fzj1G9mSFqPg2A71pspHsTTD2Y5hmPXFuVUXRzFj6NevVRUHriDerhw5JcNkXV -p nixos"
    };
  '';
  configurePhase = ''
  mkdir -p $out/bin
  export C_INCLUDE_PATH=$out
  cp $ConfigText $out/config.h
  export PREFIX=$out
   '';
#  mv AFKCommands $out/bin/AFKCommands
#  installPhase = ''
#  mv AFKCommands $out/bin/AFKCommands
#  '';
  meta = with lib; {
    homepage = "https://github.com/ISnortPennies/AFKCommands";
    description = "";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
