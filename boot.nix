{pkgs, config, lib, modulesPath, ...}:
{
## NEED THIS OR WONT BOOT
imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
### NEED THIS OR WONT BOOT
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "uas" "usb_storage" "sd_mod" ];
      kernelModules = [];
    };
    kernelModules = [ "kvm-amd" ];
    blacklistedKernelModules = [ "nouveau" "lbm-nouveau" "pcspkr" ];
    extraModprobeConfig = "";
    kernelParams = [ "fbcon=nodefer" "bgrt_disable" "quiet" "splash" ];
    plymouth = {
      enable = true;
      theme = "breeze";
      logo = ./images/nixos.png;
      };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
    efi.canTouchEfiVariables = true;
    timeout = 0;
    };
  };
}
