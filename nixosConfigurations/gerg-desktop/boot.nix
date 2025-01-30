{
  lanzaboote,
  config,
  lib,
  pkgs,
}:
let
  windowsConf = ''
    title  Windows
    efi     /shellx64.efi
    options -nointerrupt -noconsolein -noconsoleout HD2d65535a1:EFI\Microsoft\Boot\Bootmgfw.efi
  '';
in
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [
    pkgs.sbctl
    (pkgs.writeShellScriptBin "windows" ''
      bootctl set-oneshot windows.conf
      bootctl set-timeout-oneshot 1
      reboot
    '')
  ];
  systemd.tmpfiles.rules = [
    "L+ /var/lib/sbctl  - - - - /persist/secureboot"
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 10;
      package = lib.mkForce (
        pkgs.writeShellApplication {
          name = "lzbt";
          runtimeInputs = [
            lanzaboote.packages.tool
            pkgs.coreutils
            pkgs.sbctl
          ];
          text = ''
            lzbt "$@"
            MP='${config.boot.loader.efi.efiSysMountPoint}'
            cp -f '${pkgs.edk2-uefi-shell.efi}' "$MP/shellx64.efi"
            mkdir -p "$MP/loader/entries"
            sbctl sign -s "$MP/shellx64.efi"
            cat << EOF > "$MP/loader/entries/windows.conf"
            ${windowsConf}
            EOF
          '';
        }
      );
    };

    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        extraFiles."shellx64.efi" = pkgs.edk2-uefi-shell.efi;
        extraEntries."windows.conf" = windowsConf;
      };
      grub.enable = lib.mkForce false;
      timeout = lib.mkForce 5;
      efi.efiSysMountPoint = "/efi22";
    };
  };
}
