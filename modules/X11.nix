_: {
  config,
  pkgs,
  options,
  lib,
  ...
}:
with lib; let
  cfg = config.localModules.X11Programs;
in {
  options.localModules.X11Programs = {
    picom.enable = mkEnableOption "";
    sxhkd.enable = mkEnableOption "";
  };
  config = mkMerge [
    {
      services.xserver = {
        exportConfiguration = true;
        layout = "us";
        libinput.enable = true;
        xautolock.enable = false;
        excludePackages = [pkgs.xterm];
        desktopManager.xterm.enable = false;
      };
    }

    (
      mkIf cfg.picom.enable {
        services.picom = {
          enable = true;
          backend = "glx";
          shadow = false;
          shadowOpacity = 0.5;
          vSync = false;
          settings = {
            blur = false;

            shadow-radius = 12;
            frame-opacity = 1.0;
            inactive-opacity-override = false;
            corner-radius = 12;
            rounded-corners-exclude = [
              "window_type = 'desktop'"
              "window_type = 'tooltip'"
            ];
            mark-wmwin-focused = true;
            mark-ovredir-focused = true;
            detect-rounded-corners = true;
            detect-client-opacity = true;
            detect-transient = true;
            use-damage = true;
            log-level = "warn";
            wintypes = {
              tooltip = {
                fade = true;
                shadow = false;
                opacity = 1.0;
                focus = true;
                full-shadow = false;
              };
              dock = {shadow = true;};
              dnd = {shadow = true;};
              popup_menu = {opacity = 1.0;};
              dropdown_menu = {opacity = 1.0;};
            };
          };
        };
      }
    )
    (
      let
        configFile = pkgs.writeText "sxhkdrc" ''
          XF86AudioPlay
            playerctl play-pause
          XF86AudioPause
            playerctl play-pause
          XF86AudioStop
            playerctl stop
          XF86AudioNext
            playerctl next
          XF86AudioPrev
            playerctl previous
          XF86AudioRaiseVolume
            amixer sset Master 40+
          XF86AudioLowerVolume
            amixer sset Master 40-
          XF86AudioMute
            amixer sset Master toggle
          XF86MonBrightnessUp
            brightnessctl s 20+
          XF86MonBrightnessDown
            brightnessctl s 20-
          Print
            maim $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg
          Print + shift
            maim | xclip -selection clipboard -t image/png
          super + Print
            maim -s $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg
          super + Print + shift
            maim -s | xclip -selection clipboard -t image/png
        '';
      in
        mkIf cfg.sxhkd.enable
        {
          environment.systemPackages = [
            pkgs.maim #screenshooter
            pkgs.brightnessctl #brightness control for laptop
            pkgs.playerctl #music control
            pkgs.xclip
            pkgs.coreutils
          ];
          services.xserver.displayManager.sessionCommands = "${pkgs.sxhkd}/bin/sxhkd -c ${configFile} &";
        }
    )
  ];
}
