{
  stdenv,
  writeShellScriptBin,
  fetchzip,
  glibc,
}: let
  src = fetchzip {
    url = "https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz";
    sha256 = "sha256-qM/YIMqcntVYD8zJGCORQgIn1h4J4CDobyXwcdK3li8=";
    stripRoot = false;
  };
in
  writeShellScriptBin "t-rex"
  ''
    LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${glibc}/lib/:/run/opengl-driver/lib/
    exec ${glibc}/lib64/ld-linux-x86-64.so.2 \
    ${src}/t-rex --no-watchdog "$@"
  ''
