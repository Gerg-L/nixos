_: {
  services.xserver = {
    #fix nasty screen tearing
    screenSection = ''
      Option "TearFree" "true"
    '';
    #set monitor as primary
    #set refreshrate to 144 instead of default(60)
    #disable DPMS(screen turning off)
    monitorSection = ''
      Option      "Primary" "true"
      Modeline "1920x1080_144" 332.75 1920 1952 2016 2080 1080 1084 1089 1111 +HSync +VSync
      Option "PreferredMode" "1920x1080_144"
      Option "DPMS" "false"
    '';
    #disable screen blanking in total
    serverFlagsSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "BlankTime" "0"
    '';
  };
}
