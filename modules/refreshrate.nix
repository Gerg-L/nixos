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
    monitorSection = ''
      Option "DPMS" "false"
      '';
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "DPMS" "false"
      '';
  };
}
