{
  settings,
  lib,
  inputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs settings;};
    users = {
      ${settings.username} = {
        imports =
          [
            ./spicetify.nix
          ];
        xsession.numlock.enable = true;
        home = {
          homeDirectory = "/home/${settings.username}";
          stateVersion = settings.version;
        };
      };
    };
  };
}
