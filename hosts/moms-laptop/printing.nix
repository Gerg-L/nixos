_: {pkgs, ...}: let
  xsane =
    pkgs.xsane.override {gimpSupport = true;};
in {
  local.allowedUnfree = ["hplip"];
  environment.systemPackages = [
    xsane
    pkgs.gimp
    pkgs.libreoffice
  ];
  users.users.jo.extraGroups = ["scanner" "lp" "cups"];
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };
  systemd.user.tmpfiles.users.jo.rules = ["L %h/.config/GIMP/2.10/plug-ins/xsane - - - - ${xsane}"];
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };
  _file = ./printing.nix;
}
