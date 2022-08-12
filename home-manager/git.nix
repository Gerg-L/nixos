{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "ISnortPennies";
    userEmail = "ISnortPennies@protonmail.com";
  };
}
