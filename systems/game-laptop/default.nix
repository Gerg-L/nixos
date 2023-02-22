inputs: {
  pkgs,
  settings,
  ...
}: {
  imports = [
    (import ./prime.nix inputs)
    (import ./gaming.nix inputs)

    (import ../imports/fonts.nix inputs)
    (import ../imports/git.nix inputs)
    (import ../imports/shells.nix inputs)
    (import ../imports/theme.nix inputs)
  ];

  localModules = {
    DE.gnome.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
  };
  nixpkgs.allowedUnfree = [
    "nvidia-x11"
    "nvidia-persistenced"
    "steam"
    "steam-original"
    "steam-run"
  ];
  system.stateVersion = "23.05";
  environment.systemPackages = [
    pkgs.pavucontrol #gui volume control
    pkgs.pcmanfm #file manager
    pkgs.librewolf #best browser
    pkgs.webcord
  ];
  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  users = {
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["audio" "networkmanager"];
    };
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
    kernelModules = ["kvm-amd"];
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0822f37a-e55b-4b56-aeae-b6f4a11306c3";
      fsType = "ext4";
      label = "nixos";
      noCheck = false;
      mountPoint = "/";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EA2C-E488";
      fsType = "vfat";
      label = "BOOT";
      noCheck = false;
      mountPoint = "/boot";
      neededForBoot = true;
    };
  };
}
