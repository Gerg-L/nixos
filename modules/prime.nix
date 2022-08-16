{ config, ... }:
{
  hardware.nvidia.prime = {
    sync.enable = true;
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

