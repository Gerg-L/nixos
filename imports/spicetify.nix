{
  spicetify-nix,
  master,
  ...
}: {pkgs, ...}: let
  sp-nix = spicetify-nix;
  spicePkgs = sp-nix.packages.${pkgs.system}.default;
  unfree = import master {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  nixpkgs.allowedUnfree = ["spotify"];
  imports = [sp-nix.nixosModule];
  programs.spicetify = {
    spotifyPackage = unfree.spotify-unwrapped;
    spicetifyPackage = pkgs.spicetify-cli;
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "custom";
    customColorScheme = {
      text = "f8f8f8";
      subtext = "f8f8f8";
      sidebar-text = "79dac8";
      main = "000000";
      sidebar = "323437";
      player = "000000";
      card = "000000";
      shadow = "000000";
      selected-row = "7c8f8f";
      button = "74b2ff";
      button-active = "74b2ff";
      button-disabled = "555169";
      tab-active = "80a0ff";
      notification = "80a0ff";
      notification-error = "e2637f";
      misc = "282a36";
    };
  };
}
