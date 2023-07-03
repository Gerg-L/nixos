{spicetify-nix, ...}: {pkgs, ...}: let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  ex = spicePkgs.extensions;
in {
  imports = [spicetify-nix.nixosModule];
  nixpkgs.allowedUnfree = ["spotify"];
  programs.spicetify = {
    enable = true;
    enabledExtensions = [
      ex.adblock
      ex.hidePodcasts
      ex.shuffle
    ];
    theme = spicePkgs.themes.Comfy;
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
