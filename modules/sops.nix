{
  sops-nix,
  self,
  ...
}: {
  pkgs,
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
    defaultSopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
  _file = ./sops.nix;
}
