{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
    config = {
      user = {
        name = "ISnortPennies";
        email = "ISnortPennies@protonmail.com";
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
}
