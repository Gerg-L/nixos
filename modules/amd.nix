{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
}
