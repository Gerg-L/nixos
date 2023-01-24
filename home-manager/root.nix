{settings, ...}: {
  imports = [
    ./theme.nix
    ./neovim
  ];
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
