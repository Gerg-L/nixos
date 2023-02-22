_: {
  pkgs,
  settings,
  self,
  ...
}: {
  boot = {
    kernelParams = ["amd_iommu=on" "iommu=pt" "vfio_iommu_type1.allow_unsafe_interrupts=1" "kvm.ignore_msrs=1"];
    kernelModules = ["kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];
    initrd.kernelModules = ["vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];
    extraModprobeConfig = ''
      options vfio-pci ids=10de:228e,10de:2504
    '';
  };
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        ovmf.enable = true;
        verbatimConfig = ''
          user = "${settings.username}"
          group = "kvm"
          namespaces = []
        '';
      };
    };
  };
  environment = {
    systemPackages = [pkgs.virt-manager];
    shellAliases = {
      vm-start = "virsh start Windows";
      vm-stop = "virsh shutdown Windows";
    };
  };

  users.users."${settings.username}".extraGroups = ["kvm" "libvirtd"];

  systemd.tmpfiles.rules = let
    xml = pkgs.writeText "Windows.xml" (builtins.readFile "${self}/misc/Windows.xml");
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.stdenv.shell}
      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      if [ "$GUEST_NAME" == "Windows" ]; then
        if [ "$OPERATION" == "start" ]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=8-15,24-31
          systemctl set-property --runtime -- system.slice AllowedCPUs=8-15,24-31
          systemctl set-property --runtime -- init.scope AllowedCPUs=8-15,24-31
        fi

        if [ "$OPERATION" == "stopped" ]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
        fi
      fi
    '';
  in [
    "L+ /var/lib/libvirt/hooks/ - - - - ${qemuHook}"
    "L+ /var/lib/libvirt/qemu/Windows.xml - - - - ${xml}"
  ];
}
