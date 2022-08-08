{
  services.xserver = {
    xrandrHeads = [
      {
        output = "HDMI-0";
        primary = true;
      }
    ];
    screenSection = '' 
    Option         "metamodes" "1920x1080_144 +0+0"
    '';
  };
}
