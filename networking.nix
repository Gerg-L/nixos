{ lib, ...}:

{
  networking = {
    firewall.enable = true;
    hostName = "gerg-laptop";
    useDHCP = lib.mkDefault true;
    networkmanager. enable = true;
  };
}
