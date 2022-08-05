{
  services.xserver = {
    xrandrHeads = [
      {
        output = "HDMI-0";
        primary = true;
        monitorConfig = ''
          DisplaySize 1920 1080
          Option "DPMS" "false"
        '';
      }
    ];
    screenSection = '' 
    Option         "metamodes" "1920x1080_144 +0+0"
    '';
  };
}
