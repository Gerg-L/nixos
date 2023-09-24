_:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.X11Programs;
in
{
  options.local.X11Programs = {
    sxhkd.enable = lib.mkEnableOption "";
  };
  config = lib.mkMerge [
    {
      services.xserver = {
        tty = lib.mkDefault 1;
        exportConfiguration = true;
        layout = "us";
        libinput.enable = true;
        xautolock.enable = false;
        excludePackages = [ pkgs.xterm ];
        desktopManager.xterm.enable = false;
      };
    }
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
      lib.mkIf cfg.sxhkd.enable {
        environment.systemPackages = [
          pkgs.maim # screenshooter
          pkgs.brightnessctl # brightness control for laptop
          pkgs.playerctl # music control
          pkgs.xclip
        ];
        services.xserver.displayManager.sessionCommands = ''
          ${lib.getExe' pkgs.sxhkd "sxhkd"} -c ${configFile} &
        '';
      }
    )
  ];
  _file = ./X11.nix;
}
