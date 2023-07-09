{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  chafa,
  dbus,
  dconf,
  glib,
  imagemagick_light,
  libglvnd,
  libpulseaudio,
  libxcb,
  libXrandr,
  networkmanager,
  ocl-icd,
  opencl-headers,
  pciutils,
  rpm,
  sqlite,
  vulkan-loader,
  wayland,
  xfce,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-l9fIm7+dBsOqGoFUYtpYESAjDy3496rDTUDQjbNU4U0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    chafa
    dbus
    dconf
    glib
    imagemagick_light
    libglvnd
    libpulseaudio
    libxcb
    libXrandr
    networkmanager
    ocl-icd
    opencl-headers
    pciutils
    rpm
    sqlite
    vulkan-loader
    wayland
    xfce.xfconf
    zlib
  ];

  preBuild = ''
    export TRASH=$(mktemp -d)
  '';

  cmakeFlags = [
    "-DTARGET_DIR_ETC=$(TRASH)"
  ];

  meta = with lib; {
    description = "Like neofetch, but much faster because written in C";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [gerg-l];
  };
})
