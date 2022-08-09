{
  services.xserver = {
    xrandrHeads = [
      {
        output = "HDMI-0";
        primary = true;
        monitorConfig = ''
          Option "DPMS" "false"
        '';
      }
    ];
    screenSection = '' 
    Option         "metamodes" "1920x1080_144 +0+0"
    '';
  };
}
