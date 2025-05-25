{
  lib,
  pkgs,
  config,
}:
{
  options.local.zellij = lib.mkEnableOption "zellij" // {
    default = true;
  };

  config = lib.mkIf config.local.zellij {
    local.packages = {
      inherit (pkgs) zellij;
    };

    programs.zsh.interactiveShellInit =
      let
        monitorScript = pkgs.replaceVarsWith {
          src = ./monitor.ps;
          replacements = builtins.mapAttrs (_: lib.getExe) {
            inherit (pkgs) perl xdotool;
          };
          isExecutable = true;
        };
      in
      ''
        if [[ -z "$ZELLIJ" ]]; then
          if [[ -n "$SSH_TTY" ]]; then
            zellij attach -c "SSH@$USER"
          else
            MONITOR="$(${monitorScript} || true)"
            zellij attach -c "''${MONITOR:+"$MONITOR@"}$USER"
          fi
          exit
        fi
      '';

  };
}
