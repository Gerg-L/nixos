_: {config, ...}: {
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
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
  _file = ./prime.nix;
}
