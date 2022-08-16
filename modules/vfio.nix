{ pkgs, ... }:
{
  boot = {
    kernelParams = [ "amd_iommu=on" "kvm.ignore_msrs=1" ];
    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    initrd.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
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
        user = "gerg"
        group = "kvm"
        namespaces = []
        '';
      };
    };
  };
  environment.systemPackages = with pkgs; [   virt-manager  ];
  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.stdenv.shell}

      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      if [ "$GUEST_NAME" == "Main_VM" ]; then
        if [ "$OPERATION" == "start" ]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,2,6,7,8
          systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,2,6,7,8
          systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,2,6,7,8
        fi

        if [ "$OPERATION" == "stopped" ]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-11
        fi
      fi
    '';
  in ''
    mkdir -p /var/lib/libvirt/hooks
    chmod 755 /var/lib/libvirt/hooks

    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  '';
}
