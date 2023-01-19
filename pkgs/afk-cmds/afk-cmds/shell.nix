let
  pkgs = import <nixpkgs> { };
in
with pkgs;
mkShell rec {
  buildInputs = with pkgs; [
    xorg.libXScrnSaver
    xorg.libX11
    # Dev dependencies
    rustup
    pkg-config
    gdk-pixbuf
    gtkmm3
    libappindicator-gtk3
  ];
  LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  RUST_BACKTRACE = 1;
}
