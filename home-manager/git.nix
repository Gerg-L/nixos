{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
    userName = "ISnortPennies";
    userEmail = "ISnortPennies@protonmail.com";
  };
}
