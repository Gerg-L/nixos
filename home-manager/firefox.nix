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
              sha256 = "9hmYqb5R8KOILNYylTspMr6CEmlLMg24JCGDFH0KA9k=";
            } + "/user.js") );
        };
      };
    };
  };
}
