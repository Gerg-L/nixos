{sops-nix, ...}: {
  pkgs,
  settings,
  self,
  config,
  lib,
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
    age = {
      sshKeyPaths = lib.mkForce ["/home/${settings.username}/.ssh/id_ed25519"];
      keyFile = "/etc/sops/age/keys.txt";
      generateKey = true;
    };
  };
}
