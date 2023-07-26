_: {pkgs, ...}: {
  local.allowedUnfree = ["hplip"];
  environment.systemPackages = [
    pkgs.gimp
    (pkgs.xsane.override {gimpSupport = true;})
    pkgs.libreoffice
  ];
  users.users.jo.extraGroups = ["scanner" "lp" "cups"];
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };
  systemd.tmpfiles.rules = ["L /home/jo/.config/GIMP/2.10/plug-ins/xsane - - - - /run/current-system/sw/bin/xsane"];
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };
  _file = ./printing.nix;
}
