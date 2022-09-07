
{pkgs , ... }:
{
  services.polybar = {
    enable =  true;
    package = pkgs.polybarFull;
    script = "polybar left & \n polybar middle & \n polybar right &";
    settings = {
      "settings" = {
        screenchange.reload = true;
        pseudo.transparency =false;
      };
      "colors" = {
        background = "#000000";
        foreground = "#495eb8";
        blue = "#7aa2f7";
        alert = "#ad032e";
        deepblue = "#03339c";
      };
      "bar/left" = {
        width = "180px";
        offset.x = 10;
        modules.center = "xworkspaces";
        height = "20pt";
        radius = 6;
        fixed.center = false;
        dpi = 96;
        offset.y = 10;
        font = [ "Overpass Nerd Font:style=Regular:size=14;4"  "Material Design Icons:style=Regular:size=16;4" ];
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line.size = "3pt";
        border = {
          size = "7pt";
          color = "\${colors.background}";
          radius = 7;
        };
        padding = {
          left = 0;
          right = 0;
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
        enable.ipc = true;
        wm.restack = "bspwm";
      };
      "bar/middle" = {
        width = "130px";
        offset.x = 895;
        modules.center = "date";
        height = "20pt";
        radius = 6;
        fixed.center = false;
        dpi = 96;
        offset.y = 10;
        font = [ "Overpass Nerd Font:style=Regular:size=14;4"  "Material Design Icons:style=Regular:size=16;4" ];
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line.size = "3pt";
        border = {
          size = "7pt";
          color = "\${colors.background}";
          radius = 7;
        };
        padding = {
          left = 0;
          right = 0;
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
        enable.ipc = true;
        wm.restack = "bspwm";
      };
      "bar/right" = {
        width = "180px";
        offset.x = 1730;
        modules.center = "tray pulseaudio network-wireless network-wired battery powermenu";
        height = "20pt";
        radius = 6;
        fixed.center = false;
        dpi = 96;
        offset.y = 10;
        font = [ "Overpass Nerd Font:style=Regular:size=14;4"  "Material Design Icons:style=Regular:size=16;4" ];
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line.size = "3pt";
        border = {
          size = "7pt";
          color = "\${colors.background}";
          radius = 7;
        };
        padding = {
          left = 0;
          right = 0;
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
        enable.ipc = true;
        wm.restack = "bspwm";
      };
      "bar/tray" = {
        width = "180px";
        offset.x = 1550;
        module.margin.left = 0;
        module.margin.right = 0;
        modules.right = "sep";
        tray = {
          position = "right";
          detached = false;
          offset.x = 0;
          offset.y = 0;
          padding = 1;
          maxsize = 180;
          scale = "1.0";
          background = "\${colors.background}";
          transparent = false;
        };
        height = "20pt";
        radius = 6;
        fixed.center = false;
        dpi = 96;
        offset.y = 10;
        font = [ "Overpass Nerd Font:style=Regular:size=14;4"  "Material Design Icons:style=Regular:size=16;4" ];
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line.size = "3pt";
        border = {
          size = "7pt";
          color = "\${colors.background}";
          radius = 7;
        };
        padding = {
          left = 0;
          right = 0;
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
        enable.ipc = true;
        wm.restack = "bspwm";
      };
      "module/sep" = {
        type = "custom/text";
        content = {
          text = " ";
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
        };
      };
      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label = {
          active = {
            text = "";
            foreground = "\${colors.blue}";
            background = "\${colors.background}";
            padding = 2;
          };
          occupied = {
            text = "";
            foreground = "\${colors.deepblue}";
            background = "\${colors.background}";
            padding = 2;
          };
          urgent = {
            text = "";
            foreground = "\${colors.alert}";
            background = "\${colors.background}";
            padding = 2;
          };
          empty = {
            text = "";
            foreground = "\${colors.background}";
            background = "\${colors.background}";
            padding = 2;
          };
        }; 
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = {
          text = "\"%I:%M %p\"";
          alt = "\"%a,  %B %d\"";
        };
        label = {
          text = "\"%date%%{A}\"";
          foreground = "\${colors.foreground}";
          background = "\${colors.background}";
        };
      };
      "module/tray" = {
        type = "custom/text";
        content = " ";
        click.left = "polybar-tray";
        label = {
          padding = 3;
          background = "\${colors.background}";
        };
      };
      "module/network-wireless" = {
        type = "internal/network";
        interface.type = "wireless";
        interval = "3.0";
        udspeed.minwidth = 5;
        accumulate.stats = true;
        unknown.as.up = true;
        format = {
          connected = "\"%{A1:networkmanager_dmenu:}<ramp-signal>%{A}\"";
          disconnected =  "\"%{A1:networkmanager_dmenu:}<label-disconnected>%{A}\"";
        };
        label.disconnected = {
          text = "";
          padding = 0;
        };
        ramp.signal = {
          text = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          foreground = "\${colors.foreground}";
          background = "\${colors.background}";
          padding = 1;
        };
      };
      "module/network-wired" = {
        type = "internal/network";
        interface.type = "wired";
        interval = "3.0";
        udspeed.minwidth = 5;
        accumulate.stats = true;
        unknown.as.up = true;
        format = {
          connected = "\"%{A1:networkmanager_dmenu:}<label-connected>%{A}\"";
          disconnected =  "\"%{A1:networkmanager_dmenu:}<label-disconnected>%{A}\"";
        };
        label.connected = {
          text = "";
          foreground = "\${colors.foreground}";
          background = "\${colors.background}";
          padding = 1;
        };
        label.disconnected = {
          text = "";
        };
      };
      "module/powermenu" = {
        type = "custom/text";
        content = {
          text = "";
          foreground = "\${colors.alert}";
          background = "\${colors.background}";
          padding = 3;
        };
        click.left = "\$HOME/.config/rofi/powermenu/powermenu.sh";
      };
      "module/battery" = {
        type = "internal/battery";
        full.at = 100;
        low.at = 20;
#        battery = "BAT0";
#        adapter = "ACAD";
        poll.interval = 5;
        format = {
          charging = "\"%{A1:xfce4-power-menu -c:}<animation-charging>%{A}\"";
          discharging = "\"%{A1:xfce4-power-menu -c:}<ramp-capacity>%{A}\"";
          low = "\"%{A1:xfce4-power-menu -c:}<animation-low>%{A}\"";
          full = "\"%{A1:xfce4-power-menu -c:}<ramp-capacity>%{A}\"";
        };
        label = {
          charging = {
            text = "\"%percentage%%\"";
            padding = 1;
          };
          discharging = {
            text = "\"%percentage%%\"";
            padding = 1;
          };
          low = {
            text = "\"%percentage%%\"";
            padding = 1;
          };
        };
        animation = {
          charging = {
            text = [ "   " "   " "   " "   " "   " ];
            foreground = "\${colors.deepblue}";
            background = "\${colors.background}";
            framerate = 750;
          };
          discharging.framerate = 500;
          low = {
            text = [ "  " "  " ];
            framerate = 200;
            foreground =  "\${colors.alert}";
            background = "\${colors.background}";
          };
        };
        ramp.capacity = {
          text = [ "   " "   " "   " "   " "   " ];
          background = "\${colors.background}"; 
        };
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        use.ui.max = false;
        interval = 5;
        format = {
          volume = "\"%{A1:pavucontrol:}<ramp-volume>%{A}\"";
          muted = "\"%{A1:pavucontrol:}<label-muted>%{A}\"";
        };
        label = {
          muted = {
            text = "ﱝ";
            foreground = "\${colors.alert}";
            background = "\${colors.background}";
            padding = 1;
          };
        };
        ramp.volume = {
          text = [ "奄" "奔" "墳" ];
          background = "\${colors.background}";
          padding = 1;
          click.right = "amixer sset Master toggle";
        };
      };
    };
  };
}
