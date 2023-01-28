{
  settings,
  lib,
  ...
}: {
  imports = let
    modules = [
      "theme"
    ];
  in
    lib.lists.forEach modules (
      m:
        ./. + ("/" + m + ".nix")
    );
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = settings.version;
    file = {
      ".config/neofetch/config.conf" = {
        source = ./config/neofetch/config.conf;
        recursive = false;
      };
    };
  };
}
