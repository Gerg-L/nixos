{ pkgs, lib, spicetify-nix, ... }:
let
    spotifyNoPremiumSrc = pkgs.fetchgit {
    url = "https://github.com/Daksh777/SpotifyNoPremium";
    rev = "a2daa7a9ec3e21ebba3c6ab0ad1eb5bd8e51a3ca";
    sha256 = "1sr6pjaygxxx6majmk5zg8967jry53z6xd6zc31ns2g4r5sy4k8d";
  };
in
{
  imports = [ spicetify-nix.homeManagerModule ];
  programs.spicetify = {
    spotifyPackage = pkgs.spotify-unwrapped;
    spicetifyPackage = pkgs.spicetify-cli;
    enable = true;
    enabledExtensions = with spicetify-nix.pkgs.extensions; [
      "adblock.js"
      "hidePodcasts.js"
    ];
    theme = {
      name = "spotifyNoPremium";
      src = spotifyNoPremiumSrc;
      appendName = false;
      injectCss = true;
      replaceColors = false;
      overwriteAssets = false;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = spotifyNoPremiumSrc;
          filename = "adblock.js";
        }
      ];
    };
  };
}
