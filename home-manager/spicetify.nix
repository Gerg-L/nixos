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
      "shuffle+.js"
    ];
  theme = spicetify-nix.pkgs.themes.Dribbblish;
  colorScheme = "custom";
      customColorScheme = {
        text = "7AA2F7";
        subtext = "F0F0F0";
        sidebar-text = "7AA2F7";
        main = "000000";
        sidebar = "000000";
        player = "000000";
        card = "000000";
        shadow = "03339c";
        selected-row = "797979";
        button = "31748f";
        button-active = "7AA2F7";
        button-disabled = "03339c";
        tab-active = "166632";
        notification = "1db954";
        notification-error = "eb6f92";
        misc = "FFFFFF";
      };
  };
}
