{ lib, self' }:
{
  # I manually switch this sometimes
  config = lib.mkIf true {
    networking.firewall = {
      allowedUDPPorts = [ 24454 ];
      allowedTCPPorts = [
        25565
        25575
      ];
    };

    users = {
      users.minecraft = {
        home = "/persist/minecraft2";
        createHome = true;
        isSystemUser = true;
        group = "minecraft";
      };
      groups.minecraft = { };
    };

    systemd.services.minecraft-server = {
      description = "Minecraft";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = ''
        ${lib.getExe self'.packages.fabric} \
        -Xms12G \
        -Xmx12G \
        -XX:+UnlockExperimentalVMOptions \
        -XX:+UnlockDiagnosticVMOptions \
        -XX:+AlwaysActAsServerClassMachine \
        -XX:+AlwaysPreTouch \
        -XX:+DisableExplicitGC \
        -XX:+UseNUMA \
        -XX:NmethodSweepActivity=1 \
        -XX:ReservedCodeCacheSize=400M \
        -XX:NonNMethodCodeHeapSize=12M \
        -XX:ProfiledCodeHeapSize=194M \
        -XX:NonProfiledCodeHeapSize=194M \
        -XX:-DontCompileHugeMethods \
        -XX:MaxNodeLimit=240000 \
        -XX:NodeLimitFudgeFactor=8000 \
        -XX:+UseVectorCmov \
        -XX:+PerfDisableSharedMem \
        -XX:+UseFastUnorderedTimeStamps \
        -XX:+UseCriticalJavaThreadPriority \
        -XX:ThreadPriorityPolicy=1 \
        -XX:AllocatePrefetchStyle=3
      '';

      serviceConfig = {
        Restart = "always";
        User = "minecraft";
        WorkingDirectory = "/persist/minecraft2";

        StandardInput = "journal";
        StandardOutput = "journal";
        StandardError = "journal";

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
        UMask = "0077";
      };
      preStart = ''
        if [ ! -e "eula.txt" ]; then
          echo "eula=true" > eula.txt
        fi
      '';
    };
  };
}
