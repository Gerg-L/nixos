{
  fetchurl,
  runCommand,
  imagemagick,
}:
runCommand "images"
  {
    recursion = fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/raw/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-recursive.png";
      hash = "sha256-YvFrlysNGMwJ7eMFOoz0KI8AjoPN3ao+AVOgnVZzkFE=";
    };
    logo = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/376ed4ba8dc2e611b7e8a62fdc680967ead5bd87/logo/nix-snowflake.svg";
      hash = "sha256-SCuQlSPB14GFTq4XvExJ0QEuK2VIbrd5YYKHLRG/q5I=";
    };
    buildInputs = [ imagemagick ];
  }
  ''
    mkdir -p $out
    cp $recursion $out/recursion.png
    convert -background none -size 512x512 $logo $out/logo.png
  ''
