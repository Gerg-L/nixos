{
  self',
  pkgs,
}:
{
  local.minecraft-servers = {
    fabric = {
      enable = false;
      script = ''
        java \
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
        -XX:AllocatePrefetchStyle=3 \
        -jar ${self'.packages.fabric} \
        nogui
      '';
      ports = {
        TCP = [ 25565 ];
        UDP = [ 24454 ];
      };
    };
    paper = {
      enable = false;
      script = ''
        java \
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
        -XX:AllocatePrefetchStyle=3 \
        -jar ${self'.packages.papermc} \
        nogui
      '';
      ports.TCP = [ 25565 ];
    };
  };
}
