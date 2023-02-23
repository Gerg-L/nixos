_: {
  pkgs,
  settings,
  ...
}: {
  nixpkgs.allowedUnfree = ["hplip"];
  environment.systemPackages = [
    pkgs.gimp
    (pkgs.xsane.override {gimpSupport = true;})
    pkgs.libreoffice
  ];
  users.users."${settings.username}".extraGroups = ["scanner" "lp" "cups"];
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
    #run this to setup gimp plugin
    #ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
  };
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };
}
