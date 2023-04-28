{
  stdenv,
  fetchzip,
  glibc,
}: let
  wrapper = ''
    #!/bin/sh
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${glibc}/lib/:/run/opengl-driver/lib/
    exec ${glibc}/lib64/ld-linux-x86-64.so.2 \
    $out/t-rex --no-watchdog \$@
  '';
  version = "0.26.5";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "t-rex-miner";
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
  }
