{ pkgs, lib, spicetify-nix, ... }:
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
    theme = spicetify-nix.pkgs.themes.SpotifyNoPremium;
  };
}
