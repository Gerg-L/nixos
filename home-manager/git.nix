{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "ISnortPennies";
    userEmail = "ISnortPennies@protonmail.com";
  };
}
