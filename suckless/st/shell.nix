let
  pkgs = import <nixpkgs> { };
in
with pkgs;
mkShell rec {
  name = "build-st";
  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXft
    xorg.libXcursor
  ];
  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];

  preInstall = ''
    export TERMINFO=$out/share/terminfo
  '';

  installFlags = [ "PREFIX=$(out)" ];

}
