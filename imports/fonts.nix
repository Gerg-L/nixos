_: {pkgs, ...}: {
  #use a better tty
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-size=10
    '';
    fonts = [
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
  systemd.services = {
    "autovt@tty1".enable = false;
    "kmsconvt@tty1".enable = false;
  };

  fonts = {
    fonts = [
      pkgs.material-design-icons
      (pkgs.nerdfonts.override
        {
          fonts = ["Overpass"];
        })
    ];
    enableDefaultFonts = false;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Overpass Nerd Font" "Material Design Icons"];
        sansSerif = ["Overpass Nerd Font" "Material Design Icons"];
        monospace = ["OverpassMono Nerd Font" "Material Design Icons"];
      };
      hinting.enable = true;
      antialias = true;
    };
  };
}
