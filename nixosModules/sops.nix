{
  config,
  lib,
  sops-nix,
  self',
}:
{
  imports = [ sops-nix.nixosModules.sops ];
  options.local.sops.disable = lib.mkEnableOption "";
  config = lib.mkIf (!config.local.sops.disable) {
    sops = {
      defaultSopsFile = "${self'}/nixosConfigurations/${config.networking.hostName}/secrets.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
