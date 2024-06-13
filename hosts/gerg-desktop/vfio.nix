{
  _dir,
  pkgs,
  lib,

}:
/*
  This section is just me bullying
  the xserver module to do what I want when I want it to
*/
let
  cfg_monitors = pkgs.writeShellApplication {
    name = "cfg_monitors";
    runtimeInputs = [
      pkgs.xorg.xrandr
      pkgs.xorg.xset
      pkgs.gawk
      pkgs.gnugrep
    ];
    text = ''
      xrandr --setprovideroutputsource \
        "$(xrandr --listproviders | grep -i AMD | sed -n 's/^.*name://p')" NVIDIA-0 \
        --output DP-0 \
        --mode 3440x1440 --rate 120 --primary --pos 0x0 \
        --output "$(xrandr | grep -e 'HDMI.* connected.*'| awk '{ print$1 }')" \
        --mode 1920x1080 --rate 144 --set TearFree on --pos 3440x360

      xset -dpms
    '';
  };
in
{
  environment.etc = {
    "Xorg/1_mon.conf".source = "${_dir}/1_mon.conf";
    "Xorg/2_mon.conf".source = "${_dir}/2_mon.conf";
  };

  services.xserver = {
    config = lib.mkForce "";

    displayManager.setupCommands = lib.mkBefore ''
      if ! [ -e "/etc/Xorg/ONE_MONITOR" ] ; then
        ${lib.getExe cfg_monitors}
      fi
    '';
  };

  systemd.tmpfiles.rules = [
    "L  /etc/X11/xorg.conf.d/99-custom.conf  - - - - /etc/Xorg/2_mon.conf"

    # Everything from here down is almost sane
    "L+ /var/lib/libvirt/qemu/Windows.xml - - - - ${_dir}/Windows.xml"
  ];

  boot = {
    kernelParams = [
      "iommu=pt"
      "amd_iommu=on"
      /*
        Switch to this if for a Intel cpu
        "intel_iommu=on"
      */
      "vfio_iommu_type1.allow_unsafe_interrupts=1"
      "kvm.ignore_msrs=1"
    ];
    kernelPatches = lib.singleton {
      name = "fix_amd_mem_access";
      patch = null;
      extraStructuredConfig.HSA_AMD_SVM = lib.kernel.yes;
    };
  };

  environment = {
    systemPackages = [
      pkgs.dmidecode
      cfg_monitors
    ];
    shellAliases = {
      vm-start = "virsh start Windows";
      vm-stop = "virsh shutdown Windows";
    };
  };

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # Patch to disable hooking the mouse via evdev at VM startup
      package = pkgs.qemu_kvm.overrideAttrs (old: {
        patches = old.patches ++ [
          (builtins.toFile "qemu.diff" ''
            diff --git a/ui/input-linux.c b/ui/input-linux.c
            index e572a2e..a9d76ba 100644
            --- a/ui/input-linux.c
            +++ b/ui/input-linux.c
            @@ -397,12 +397,6 @@ static void input_linux_complete(UserCreatable *uc, Error **errp)
                 }

                 qemu_set_fd_handler(il->fd, input_linux_event, NULL, il);
            -    if (il->keycount) {
            -        /* delay grab until all keys are released */
            -        il->grab_request = true;
            -    } else {
            -        input_linux_toggle_grab(il);
            -    }
                 QTAILQ_INSERT_TAIL(&inputs, il, next);
                 il->initialized = true;
                 return;
          '')
        ];
      });
      runAsRoot = true;
      ovmf.enable = true;
      verbatimConfig = ''
        user = "gerg"
        group = "users"
        namespaces = []
      '';
    };
    hooks.qemu = {
      # Ordering is based on the name
      "AAA" = lib.getExe (
        pkgs.writeShellApplication {
          name = "qemu-hook";

          runtimeInputs = [
            pkgs.libvirt
            pkgs.systemd
            pkgs.kmod
          ];

          text = ''
            GUEST_NAME="$1"
            OPERATION="$2"

            if [ "$GUEST_NAME" != "Windows" ]; then
              exit 0
            elif [ "$OPERATION" == "prepare" ]; then
              # Stop display-manager
              systemctl stop display-manager.service

              # Un-bind driver
              modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset

              # Detach GPU
              virsh nodedev-detach pci_0000_01_00_0
              virsh nodedev-detach pci_0000_01_00_1

              # Set allowed CPUs
              systemctl set-property --runtime -- user.slice AllowedCPUs=8-15,24-31
              systemctl set-property --runtime -- system.slice AllowedCPUs=8-15,24-31
              systemctl set-property --runtime -- init.scope AllowedCPUs=8-15,24-31

              # Dual gpu/monitor stuff
              ln -fs /etc/Xorg/1_mon.conf /etc/X11/xorg.conf.d/99-custom.conf
              touch /etc/Xorg/ONE_MONITOR
              systemctl start display-manager.service
            elif [ "$OPERATION" == "release" ]; then
              # Dual gpu/monitor stuff
              systemctl stop display-manager.service

              # Allow all CPUs
              systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
              systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
              systemctl set-property --runtime -- init.scope AllowedCPUs=0-31

              # Re-attach GPU
              virsh nodedev-reattach pci_0000_01_00_0
              virsh nodedev-reattach pci_0000_01_00_1

              # Re-bind Driver
              modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset

              # Dual gpu/monitor stuff
              ln -fs /etc/Xorg/2_mon.conf /etc/X11/xorg.conf.d/99-custom.conf
              rm /etc/Xorg/ONE_MONITOR

              # Restart display-manager
              systemctl start display-manager.service
            else
             exit 0
            fi
          '';
        }
      );
    };
  };
}
