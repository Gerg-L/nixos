{ lib
, stdenv
, writeText
, fetchFromGitHub
, xorg
, glibc
, t-rex-miner
}:
stdenv.mkDerivation rec {
  pname = "AFKCommands";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ISnortPennies";
    repo = "AFKCommands";
    rev = "6bb107e8f4ff593e1540986263fad9cb60e7e79a";
    sha256 = "sha256-toJPE/8obPXaSiw0LFRF05AIuD8gGL3YB10cn6FlvEc=";
  };

  buildInputs = [
    xorg.libXScrnSaver
    xorg.libX11
  ];
  
  ConfigText = writeText "config.h" ''
    const int AFK = 300;
    const int RESTART = 60;
    const char* COMMANDS[] = {
    "xmrig --no-color -o rx.unmineable.com:3333 -u XMR:46vHuD3G9wKVpoBV7rwQQzCRfBw3rxUo3fzj1G9mSFqPg2A71pspHsTTD2Y5hmPXFuVUXRzFj6NevVRUHriDerhw5JcNkXV.nixos",
    "t-rex --no-color -a ethash -o ethash.unmineable.com:3333 -u XMR:46vHuD3G9wKVpoBV7rwQQzCRfBw3rxUo3fzj1G9mSFqPg2A71pspHsTTD2Y5hmPXFuVUXRzFj6NevVRUHriDerhw5JcNkXV.nixos -p nixos --mt 4"
    };
  '';
  configurePhase = ''
  mkdir -p $out/bin
  export C_INCLUDE_PATH=$out
  cp $ConfigText $out/config.h
  export PREFIX=$out
   '';
  meta = with lib; {
    homepage = "https://github.com/ISnortPennies/AFKCommands";
    description = "";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
