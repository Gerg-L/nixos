{
  lib,
  pkgs,
  config,
}:
let
  cfg = config.local.ghostty;
  format = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue =
      k: v:
      if builtins.isString v then
        ''${k} = "${toString v}"''
      else
        ''${k} = ${
          if builtins.isBool v then if v then "true" else "false" else toString v
        }'';
  };
  configFile = format.generate "ghostty-config" cfg.settings;
in
{
  options.local.ghostty = {
    enable = lib.mkEnableOption "ghostty";
    settings = lib.mkOption {
      inherit (format) type;
      default = { };
    };
    defaultSettings = lib.mkEnableOption "ghostty default settings";
  };
  config = lib.mkIf cfg.enable {
    local.ghostty.settings = lib.mkIf cfg.defaultSettings (
      builtins.mapAttrs (_: lib.mkDefault) {
        window-decoration = false;
        font-size = 10;
        font-family = "Overpass Mono";

        adjust-cursor-thickness = 2;

        bold-is-bright = false;

        background = "#080808";
        foreground = "#bdbdbd";
        selection-background = "#b2ceee";
        selection-foreground = "#080808";
        cursor-color = "#8e8e8e";

        palette = [
          "0=#323437"
          "1=#ff5454"
          "2=#8cc85f"
          "3=#e3c78a"
          "4=#80a0ff"
          "5=#d183e8"
          "6=#79dac8"
          "7=#a1aab8"
          "8=#7c8f8f"
          "9=#ff5189"
          "10=#36c692"
          "11=#bfbf97"
          "12=#74b2ff"
          "13=#ae81ff"
          "14=#85dc85"
          "15=#e2637f"
        ];
        copy-on-select = false;
        clipboard-read = "allow";
        clipboard-write = "allow";
        clipboard-trim-trailing-spaces = true;
        keybind = [
          "clear"
          "ctrl+shift+v=paste_from_clipboard"
        ];

        auto-update = "off";
      }
    );

    local.packages.ghostty = pkgs.symlinkJoin {
      name = "ghostty";
      paths = [ pkgs.ghostty ];
      nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/ghostty" \
          --add-flag '--config-default-files=false' \
          --add-flag '--config-file="${configFile}"'
      '';
    };
  };
}
