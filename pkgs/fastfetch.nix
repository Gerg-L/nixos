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
  ocl-icd,
  opencl-headers,
  pciutils,
  pkg-config,
  stdenv,
  vulkan-loader,
  wayland,
  xfce,
  libX11,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-tMwHoa4Vy6QOkbASjvIiMal8TBDclF+TKWYWUwvpPeM=";
  };

  nativeBuildInputs = [cmake pkg-config];

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
    libX11
  ];
  cmakeFlags = [
    "-DTARGET_DIR_ETC=./"
  ];
  postInstall = ''
    rm -rf $out/fastfetch
  '';
})
