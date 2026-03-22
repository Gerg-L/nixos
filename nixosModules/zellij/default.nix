{
  lib,
  pkgs,
  config,
}:
{
  options.local.zellij = {
    enable = lib.mkEnableOption "zellij";
    force = lib.mkEnableOption "force";
  };

  config = lib.mkIf config.local.zellij.enable {
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
      #bash
      ''

        run_zellij () {
            if ! systemctl is-active --quiet --user "zellij$2.scope"; then
             systemd-run --scope --unit="zellij$2" --user zellij attach -b "$1"
            fi
            ${lib.optionalString config.local.zellij.force "exec "}zellij attach "$1"
        }

        if [[ -z "$ZELLIJ" ]]; then
          if [[ -n "$SSH_TTY" ]]; then
            run_zellij "$SSH@$USER" ""
          else
            MONITOR="$(${monitorScript} || true)"
            run_zellij "''${MONITOR:+"$MONITOR@"}$USER" "-''${MONITOR:+"$MONITOR"}"
          fi
        elif [ "$SHLVL" -le  "3" ]; then
          alias exit="echo 'In Zellij not exiting'"
        fi
      '';

  };
}
