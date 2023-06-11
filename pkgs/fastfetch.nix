{
  chafa,
  cmake,
  dbus,
  dconf,
  fetchFromGitHub,
  glib,
  imagemagick_light,
  libglvnd,
  libxcb,
  makeWrapper,
  ocl-icd,
  opencl-headers,
  pciutils,
  pkg-config,
  stdenv,
  vulkan-loader,
  wayland,
  xfce,
  xorg,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-sSQaXXKH/ZELdhbUKuvAj0gZ0fSO/Xjxsv/TU0Xq47k=";
  };

  nativeBuildInputs = [cmake makeWrapper pkg-config];

  buildInputs = [
    dbus
    dconf
    glib
    pciutils
    zlib
    chafa
    imagemagick_light
    ocl-icd
    libglvnd
    vulkan-loader
    wayland
    libxcb
    xfce.xfconf
    opencl-headers
    xorg.libX11
  ];
  cmakeFlags = [
    "-DTARGET_DIR_ETC=./etc"
  ];
})
