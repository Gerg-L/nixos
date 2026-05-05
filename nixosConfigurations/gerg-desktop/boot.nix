{
  lib,
  pkgs,
}:
{
  local.packages = {
    inherit (pkgs) sbctl;
    windows = pkgs.writeShellScriptBin "windows" ''
      if ! [ $(id -u) = 0 ]; then
         echo "Run as root!"
         exit 1
      fi

      NUM="$(efibootmgr | awk '/Windows/ { sub(/Boot/, "", $1); print $1 }')"
      efibootmgr --bootnext "$NUM"
      reboot
    '';
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/sbctl  - - - - /persist/secureboot"
  ];

  boot = {
    loader = {
      limine = {
        enable = true;
        biosSupport = false;
        efiSupport = true;
        maxGenerations = 10;
        enableEditor = false;
        secureBoot = {
          enable = true;
        };
        extraEntries = ''
          /Windows
              protocol: efi
              path: uuid(58952b7f-ac08-4fa3-92ad-cac5a3349199):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
      efi.efiSysMountPoint = "/efi0E";
      # just in case
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
      timeout = lib.mkForce 5;
    };
  };
}
