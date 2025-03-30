{ config, lib }:
{
  options.local.remoteBuild.enable = lib.mkEnableOption "";

  config = lib.mkMerge [
    (lib.mkIf config.local.remoteBuild.enable {
      nix = {
        settings = {
          keep-outputs = false;
          keep-derivations = false;
          builders-use-substitutes = true;
          max-jobs = 0;
          substituters = [ "https://cache.gerg-l.com?priority=-1&compression=zstd" ];
          trusted-public-keys = [ "cache.gerg-l.com:6p1+h6jQnb1MOt3ra3PlQpfgEEF4zRrQWiEuAqcjBj8=" ];
        };
        distributedBuilds = true;
        buildMachines = [
          {
            hostName = "gerg-desktop";
            protocol = "ssh-ng";
            maxJobs = 32;
            systems = [
              "x86_64-linux"
              "i686-linux"
            ];
            supportedFeatures = [
              "big-parallel"
              "nixos-test"
              "kvm"
              "benchmark"
            ];
            sshUser = "builder";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            publicHostKey = config.local.keys.gerg-desktop_fingerprint;
          }
        ];
      };
      programs.ssh.knownHosts.gerg-desktop = {
        extraHostNames = [ "gerg-desktop.lan" ];
        publicKey = config.local.keys.root_gerg-desktop;
      };
    })
  ];
}
