_: {pkgs, ...}: {
  networking = {
    hostName = "notbuntu";
    useDHCP = true;
    firewall = {
      allowPing = true;
      allowedTCPPorts = [25565];
    };
  };
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  time.timeZone = "America/New_York";
  services = {
    timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com"
      ];
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  environment.systemPackages = with pkgs; [
    neovim
    gitMinimal
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWbwkFJmRBgyWyWU+w3ksZ+KuFw9uXJN3PwqqE7Z/i8 gerg@gerg-desktop"
  ];
  system.stateVersion = "unstable";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["net.ifnames=0" "biosdevname=0"];
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "sd_mod" "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
      kernelModules = ["virtio_balloon" "virtio_console" "virtio_rng"];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/dc14282f-28a2-4858-919e-60948f60d6f0";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/0A33-1923";
      fsType = "vfat";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };
  nixpkgs.hostPlatform = "x86_64-linux";

  services.nginx = {
    enable = true;

    eventsConfig = ''
      worker_connections 768;
    '';
    appendConfig = ''
      stream {
        server {
          listen   0.0.0.0:25565 reuseport;
          proxy_pass [2605:59c8:2500:5394:cdc3:3ace:9d30:f8bc]:25565;
        }
      }
    '';
  };
}
