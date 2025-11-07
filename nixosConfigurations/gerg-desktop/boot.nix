{
  lib,
  pkgs,
}:
{
  local.packages = {
    inherit (pkgs) sbctl;
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
