{ self, ... }:
{ lib, ... }:
{
  # I manually switch this sometimes
  config = lib.mkIf false {
    networking.firewall.allowedTCPPorts = [ 25565 ];

    users.users.minecraft = {
      description = "Minecraft server service user";
      home = "/persist/minecraft";
      createHome = true;
      isSystemUser = true;
      group = "minecraft";
    };
    users.groups.minecraft = { };

    systemd.sockets.minecraft-server = {
      bindsTo = [ "minecraft-server.service" ];
      socketConfig = {
        ListenFIFO = "/run/minecraft-server.stdin";
        SocketMode = "0660";
        SocketUser = "minecraft";
        SocketGroup = "minecraft";
        RemoveOnStop = true;
        FlushPending = true;
      };
    };

    systemd.services.minecraft-server = {
      enable = true;
      description = "Minecraft Server Service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "minecraft-server.socket" ];
      after = [
        "network.target"
        "minecraft-server.socket"
      ];
      path = [ self.packages.papermc ];
      script = ''
        minecraft-server \
          -Xms8G \
          -Xmx8G \
          -XX:+UseG1GC \
          -XX:+ParallelRefProcEnabled \
          -XX:MaxGCPauseMillis=200 \
          -XX:+UnlockExperimentalVMOptions \
          -XX:+DisableExplicitGC \
          -XX:+AlwaysPreTouch \
          -XX:G1NewSizePercent=30 \
          -XX:G1MaxNewSizePercent=40 \
          -XX:G1HeapRegionSize=8M \
          -XX:G1ReservePercent=20 \
          -XX:G1HeapWastePercent=5 \
          -XX:G1MixedGCCountTarget=4 \
          -XX:InitiatingHeapOccupancyPercent=15 \
          -XX:G1MixedGCLiveThresholdPercent=90 \
          -XX:G1RSetUpdatingPauseTimePercent=5 \
          -XX:SurvivorRatio=32 \
          -XX:+PerfDisableSharedMem \
          -XX:MaxTenuringThreshold=1 \
          -Dusing.aikars.flags=https://mcflags.emc.gs-Daikars.new.flags=true \
      '';

      serviceConfig = {
        Restart = "always";
        User = "minecraft";
        WorkingDirectory = "/persist/minecraft";

        StandardInput = "socket";
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
        echo "eula=true" > eula.txt
      '';
    };
  };
  _file = ./minecraft.nix;
}
