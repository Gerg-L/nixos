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
    defaultSopsFile = self + "/systems/" + config.networking.hostName + "/secrets.yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
