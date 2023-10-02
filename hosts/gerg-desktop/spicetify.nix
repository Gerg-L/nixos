{ spicetify-nix, ... }:
{ pkgs, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ spicetify-nix.nixosModules.default ];
  local.allowedUnfree = [ "spotify" ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = builtins.attrValues {
      inherit (spicePkgs.extensions) adblock hidePodcasts shuffle;
    };
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
  _file = ./spicetify.nix;
}
