{ sops-nix, self, ... }:
{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ sops-nix.nixosModules.sops ];
  options.local.sops.disable = lib.mkEnableOption "";
  config = lib.mkIf (!config.local.sops.disable) {
    environment.systemPackages = [ pkgs.sops ];
    sops = {
      defaultSopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
  _file = ./sops.nix;
}
