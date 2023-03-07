{sops-nix, ...}: {
  pkgs,
  settings,
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
    age = {
      sshKeyPaths = ["/home/${settings.username}/.ssh/id_ed25519"];
      keyFile = "/home/${settings.username}/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };
}
