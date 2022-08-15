{ lib
, stdenv
, fetchzip
, glibc
}:
let 
wrapper = ''
  #!/bin/sh
  LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${glibc}/lib/:/run/opengl-driver/lib/ \
  ${glibc}/lib64/ld-linux-x86-64.so.2 \
  $out/t-rex --no-watchdog \$@
'';
in
stdenv.mkDerivation rec {
  pname = "t-rex-miner";
  version = "0.26.5";
  src = fetchzip {
    url = "https://github.com/trexminer/T-Rex/releases/download/${version}/t-rex-${version}-linux.tar.gz";
    sha256 = "sha256-eGOTfb03R2ck/6GMY6tPmTifYT9aVv3dNDQ5jRVlz58=";
    stripRoot = false;
  };
  installPhase = ''
  install -Dm555 $src/t-rex $out/t-rex
  mkdir -p $out/bin
  touch $out/bin/t-rex
  echo "${wrapper}" > $out/bin/t-rex
  chmod +x $out/bin/t-rex
  '';

  meta = with lib; {
  homepage = "https://github.com/ISnortPennies/AFKCommands";
  description = "";
  license = licenses.unlicense;
  maintainers = with maintainers; [ ];
  platforms = platforms.linux;
  };
}

