{unstable, ...}: {
  lib,
  config,
  pkgs,
  ...
}:
#TAKEN FROM https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/stage-2.nix
let
  useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;

  bootStage2 = pkgs.substituteAll {
    src = pkgs.runCommand "stage-2-init.sh" {} ''
      sed '2i exec 1<>/dev/null' ${unstable}/nixos/modules/system/boot/stage-2-init.sh > $out
    '';
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    shell = "${pkgs.bash}/bin/bash";
    inherit (config.boot) readOnlyNixStore systemdExecutable extraSystemdUnitPaths;
    inherit (config.system.nixos) distroName;
    isExecutable = true;
    inherit useHostResolvConf;
    inherit (config.system.build) earlyMountScript;
    path = lib.makeBinPath ([
        pkgs.coreutils
        pkgs.util-linux
      ]
      ++ lib.optional useHostResolvConf pkgs.openresolv);
    postBootCommands =
      pkgs.writeText "local-cmds"
      ''
        ${config.boot.postBootCommands}
        ${config.powerManagement.powerUpCommands}
      '';
  };
in {
  options.local.bootConfig.stage2patch.disable = lib.mkEnableOption "";
  config =
    lib.mkIf (!config.local.bootConfig.stage2patch.disable)
    {
      system.build.bootStage2 = lib.mkForce bootStage2;
    };
  _file = ./stage2patch.nix;
}
