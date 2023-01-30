{
  settings,
  lib,
  inputs,
  ...
}: let
  helperfunc = args: (lib.lists.forEach args (m: ./. + ("/" + m + ".nix")));
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs settings;};
    users = {
      ${settings.username} = {
        imports =
          helperfunc
          [
            "theme"
            "spicetify"
          ];
        xsession.numlock.enable = true;
        home = {
          homeDirectory = "/home/${settings.username}";
          stateVersion = settings.version;
        };
      };
      root = {
        imports =
          helperfunc
          [
            "theme"
          ];
        home = {
          username = "root";
          homeDirectory = "/root";
          stateVersion = settings.version;
        };
      };
    };
  };
}
