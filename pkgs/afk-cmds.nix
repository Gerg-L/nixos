{
  lib,
  rustPlatform,
  wrapGAppsHook,
  libX11,
  libXScrnSaver,
  pkg-config,
  cairo,
  glib,
  gdk-pixbuf,
  gtkmm3,
  pango,
  libappindicator-gtk3,
  atk,
  fetchFromGitHub,
}: let
  buildInputs = [
    libX11
    libXScrnSaver
    cairo
    glib
    gdk-pixbuf
    gtkmm3
    pango
    libappindicator-gtk3
    atk
  ];
in
  rustPlatform.buildRustPackage {
    name = "afk-cmds";

    src = fetchFromGitHub {
      owner = "Gerg-L";
      repo = "afk-cmds";
      rev = "b345d5a038a86c6ca31d3bd8800ac759da912a22";
      sha256 = "sha256-yleq8bg3ZnilbYTNXRteBALiJ/fIXOxXxqf966OokqQ=";
    };

    inherit buildInputs;

    nativeBuildInputs = [
      pkg-config
      wrapGAppsHook
    ];

    postFixup = ''
      wrapProgram $out/bin/afk-cmds \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      mkdir -p $out/share/icons/hicolor/256x256/apps/
      cp $src/afk-icon.png $out/share/icons/hicolor/256x256/apps/afk-icon.png
    '';
    cargoSha256 = "sha256-CPpFUdgb0zTZAVlv4uhJ0Y7eocCjuEZNgQJdNwV1FI4=";
  }
