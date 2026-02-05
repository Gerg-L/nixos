{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    local.minecraft-servers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule ({
          options = {
            enable = lib.mkEnableOption "this Minecraft server";
            java = lib.mkOption {
              type = lib.types.package;
              default = pkgs.javaPackages.compiler.temurin-bin.jdk-17;
            };
            script = lib.mkOption {
              type = lib.types.str;
            };
            serviceAttrs = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
            };
            ports = {
              TCP = lib.mkOption {
                type = lib.types.listOf lib.types.int;
                default = [ ];
              };
              UDP = lib.mkOption {
                type = lib.types.listOf lib.types.int;
                default = [ ];
              };
            };
          };
        })
      );
    };
  };
  config =
    let
      activated = lib.filterAttrs (_: v: v.enable) config.local.minecraft-servers;
    in
    lib.mkIf (activated != { }) {
      environment.systemPackages = [
        pkgs.mcrcon
      ];
      users = {
        users.minecraft = {
          home = "/persist/minecraft-servers";
          createHome = true;
          isSystemUser = true;
          group = "minecraft";
        };
        groups.minecraft = { };
      };
      networking.firewall = {
        allowedTCPPorts = builtins.concatLists (lib.mapAttrsToList (_: v: v.ports.TCP) activated);
        allowedUDPPorts = builtins.concatLists (lib.mapAttrsToList (_: v: v.ports.UDP) activated);
      };

      systemd.tmpfiles.rules = lib.mapAttrsToList (
        n: _: "d /persist/minecraft-servers/${n} 0755 minecraft minecraft - -"
      ) activated;
      systemd.services = lib.mapAttrs' (n: v: {
        name = "minecraft-server-${n}";
        value = lib.recursiveUpdate {
          inherit (v) script;
          path = [ v.java ];
          wantedBy = [ "default.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            WorkingDirectory = "/persist/minecraft-servers/${n}";

            Restart = "always";
            RestartSec = 60;
            User = "minecraft";
            Group = "minecraft";

            # Hardening
            CapabilityBoundingSet = [ "" ];
            DeviceAllow = [ "" ];
            LockPersonality = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
          };
          preStart = ''
            if [ ! -e "eula.txt" ]; then
              echo "eula=true" > eula.txt
            fi
          '';
        } v.serviceAttrs;
      }) activated;
    };

}
