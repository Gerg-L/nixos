{ lib
, rustPlatform
, fetchFromGitHub
, wrapGAppsHook
, libX11
, libXScrnSaver
, pkg-config
, cairo
, glib
, gdk-pixbuf
, gtkmm3
, pango
, libappindicator-gtk3
, atk
}:
rustPlatform.buildRustPackage rec {
  pname = "afk-cmds";
  version = "1.0.0";

  src = ./afk-cmds;

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

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  postFixup = '' 
    wrapProgram $out/bin/afk-cmds \
      --prefix LD_LIBRARY_PATH : ${(lib.makeLibraryPath buildInputs)}
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp $src/afk-icon.png $out/share/icons/hicolor/256x256/apps/afk-icon.png
  '';
  cargoSha256 = "sha256-CPpFUdgb0zTZAVlv4uhJ0Y7eocCjuEZNgQJdNwV1FI4=";

  meta = with lib; {
    homepage = "https://github.com/ISnortPennies/AFKCommands";
    description = "";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };

}

