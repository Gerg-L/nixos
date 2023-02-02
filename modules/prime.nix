{pkgs, ...}: {
  hardware.nvidia = {
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaPersistenced = true;
    nvidiaSettings = false;
    modesetting.enable = true;
  };
  services.xserver = {
    videoDrivers = ["nvidia"];
    #disable DPMS
    monitorSection = ''
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
