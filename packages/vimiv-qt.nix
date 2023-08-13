{
  lib,
  fetchFromGitHub,
  python3,
  qt5,
  installShellFiles,
}: let
  version = "0.9.0";
in
  python3.pkgs.buildPythonApplication {
    pname = "vimiv-qt";
    inherit version;

    src = fetchFromGitHub {
      owner = "karlch";
      repo = "vimiv-qt";
      rev = "v${version}";
      hash = "sha256-28sk5qDVmrgXYX2wm5G8zv564vG6GwxNp+gjrFHCRfU=";
    };

    buildInputs = [qt5.qtsvg qt5.qtwayland];

    nativeBuildInputs = [installShellFiles qt5.wrapQtAppsHook python3.pkgs.setuptools];

    propagatedBuildInputs = with python3.pkgs; [pyqt5 py3exiv2];

    postInstall = ''
      install -Dm644 misc/vimiv.desktop $out/share/applications/vimiv.desktop
      install -Dm644 misc/org.karlch.vimiv.qt.metainfo.xml $out/metainfo/org.karlch.vimiv.qt.metainfo.xml
      install -Dm644 LICENSE $out/licenses/vimiv/LICENSE
      install -Dm644 icons/vimiv.svg $out/icons/hicolor/scalable/apps/vimiv.svg
      installManPage misc/vimiv.1

      for i in 16 32 64 128 256 512; do
        install -Dm644 icons/vimiv_''${i}x''${i}.png $out/icons/hicolor/''${i}x''${i}/apps/vimiv.png
      done
    '';

    # Vimiv has to be wrapped manually because it is a non-ELF executable.
    dontWrapQtApps = true;
    preFixup = ''
      wrapQtApp $out/bin/vimiv
    '';

    meta = with lib; {
      description = "Image viewer with Vim-like keybindings (Qt port)";
      license = licenses.gpl3Plus;
      homepage = "https://github.com/karlch/vimiv-qt";
      maintainers = with maintainers; [dschrempf];
      platforms = platforms.all;
      mainProgram = "vimiv";
    };
  }
