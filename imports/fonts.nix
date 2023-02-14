_: {pkgs, ...}: {
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-size=10
    '';
    fonts = [
      {
        name = "Overpass Mono";
        package = pkgs.overpass;
      }
      {
        name = "OverpassMono Nerd Font";
        package =
          pkgs.nerdfonts.override
          {
            fonts = ["Overpass"];
          };
      }
      {
        name = "Material Design Icons";
        package = pkgs.material-design-icons;
      }
    ];
  };
  fonts = {
    fonts = with pkgs; [
      overpass
      material-design-icons
      (nerdfonts.override
        {
          fonts = ["Overpass"];
        })
    ];
    enableDefaultFonts = false;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Overpass" "Overpass Nerd Font" "Material Design Icons"];
        sansSerif = ["Overpass" "Overpass Nerd Font" "Material Design Icons"];
        monospace = ["Overpass Mono" "OverpassMono Nerd Font" "Material Design Icons"];
      };
      hinting.enable = true;
      antialias = true;
    };
  };
}
