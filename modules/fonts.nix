{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      overpass
      material-design-icons
      (nerdfonts.override
      {
        fonts = ["Overpass"];
      })
    ];
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
