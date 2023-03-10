{sops-nix, ...}: {
  pkgs,
  self,
  config,
  ...
}: {
  imports = [
    sops-nix.nixosModules.sops
  ];
  environment.systemPackages = [
    pkgs.sops
  ];
  sops = {
    defaultSopsFile = "${self}/systems/${config.networking.hostName}/secrets.yaml";
    age.keyFile = "/persist/sops/age/keys.txt";
  };
}
