{pkgs, ...}:{
  programs = {
    firefox = {
      enable = true;
      profiles = {
        gerg = {
          name = "gerg";
          extraConfig = (  builtins.readFile 
            (pkgs.fetchFromGitHub {
              owner = "ISnortPennies";
              repo = "user.js";
              rev = "master";
              sha256 = "BMEUZDelkcHDF8Yt9aa+3pGkGkodL7VEQ1hQBU6Fuug=";
            } + "/user.js") );
        };
      };
    };
  };
}
