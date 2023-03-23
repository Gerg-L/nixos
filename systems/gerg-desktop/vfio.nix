_: {
  pkgs,
  settings,
  self,
  config,
  lib,
  ...
}: let
  xcfg = config.services.xserver;
  xserverbase = let
    fontsForXServer =
      config.fonts.fonts
      ++ [
        pkgs.xorg.fontadobe100dpi
        pkgs.xorg.fontadobe75dpi
      ];
  in
    pkgs.runCommand "xserverbase"
    {
      fontpath =
        lib.optionalString (xcfg.fontPath != null)
        ''FontPath "${xcfg.fontPath}"'';
      inherit (xcfg) config;
      preferLocalBuild = true;
    }
    ''
      echo 'Section "Files"' >> $out
      echo $fontpath >> $out
      for i in ${toString fontsForXServer}; do
        if test "''${i:0:''${#NIX_STORE}}" == "$NIX_STORE"; then
          for j in $(find $i -name fonts.dir); do
            echo "  FontPath \"$(dirname $j)\"" >> $out
          done
        fi
      done
      for i in $(find ${toString xcfg.modules} -type d); do
        if test $(echo $i/*.so* | wc -w) -ne 0; then
          echo "  ModulePath \"$i\"" >> $out
        fi
      done
      echo '${xcfg.filesSection}' >> $out
      echo 'EndSection' >> $out
      echo >> $out
    '';
  oneMonitor = pkgs.writeText "1-monitor.conf" (lib.strings.concatStrings [(builtins.readFile xserverbase) (builtins.readFile "${self}/misc/1-monitor.conf")]);
  twoMonitor = pkgs.writeText "2-monitor.conf" (lib.strings.concatStrings [(builtins.readFile xserverbase) (builtins.readFile "${self}/misc/2-monitor.conf")]);
in {
  boot = {
    kernelParams = ["amd_iommu=on" "iommu=pt" "vfio_iommu_type1.allow_unsafe_interrupts=1" "kvm.ignore_msrs=1"];
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
    systemPackages = [
      pkgs.virt-manager
    ];
    shellAliases = {
      vm-start = "virsh start Windows";
      vm-stop = "virsh shutdown Windows";
    };
  };

  users.users."${settings.username}".extraGroups = ["kvm" "libvirtd"];

  #xrandr --setprovideroutputsource "AMD Radeon Graphics @ pci:0000:0f:00.0" NVIDIA-0
  #xrandr --output DP-0 --mode 3440x1440 --rate 120 --primary --pos 0x0
  #xrandr --output HDMI-A-1-0 --mode 1920x1080 --rate 144 --set TearFree on --pos 3440x360
  #xset -dpms
  #prime sync
  services.xserver.displayManager.xserverArgs = lib.mkAfter ["-config /tmp/xorg.conf"];
  services.xserver.displayManager.sessionCommands = lib.mkBefore ''
    if ! (test -e "/tmp/ONE_MONITOR"); then
          xrandr --output DP-0 --auto --mode 3440x1440 --rate 120 --primary --pos 0x0
          xrandr --output HDMI-A-1-0 --auto --mode 1920x1080 --rate 144 --set TearFree on --pos 3440x360
          xset -dpms
    fi
  '';

  systemd.tmpfiles.rules = let
    xml = pkgs.writeText "Windows.xml" (builtins.readFile "${self}/misc/Windows.xml");
    qemuHook = pkgs.writeShellScript "qemu-hook" ''
      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      if [ "$GUEST_NAME" == "Windows" ]; then
        if [ "$OPERATION" == "prepare" ]; then
            systemctl stop display-manager.service
            modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
            ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0
            ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_1
            systemctl set-property --runtime -- user.slice AllowedCPUs=8-15,24-31
            systemctl set-property --runtime -- system.slice AllowedCPUs=8-15,24-31
            systemctl set-property --runtime -- init.scope AllowedCPUs=8-15,24-31
            ln -fs ${oneMonitor} /tmp/xorg.conf
            touch /tmp/ONE_MONITOR
            systemctl start display-manager.service
        fi
        if [ "$OPERATION" == "release" ]; then
          systemctl stop display-manager.service
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
          ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0
          ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_1
          modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
          ln -fs ${twoMonitor} /tmp/xorg.conf
          rm /tmp/ONE_MONITOR
          systemctl start display-manager.service
        fi
      fi
    '';
  in [
    "L  /tmp/xorg.conf - - - - ${twoMonitor}"
    "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuHook}"
    "L+ /var/lib/libvirt/qemu/Windows.xml - - - - ${xml}"
  ];
}
