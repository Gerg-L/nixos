{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
      size = "128X128";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 400;
        height = 500;
        orgin = "bottom-right";
        offset = "20x80";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height =2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#7aa2f7";
        gap_size = 0;
        separator_color = "frame";
        sort = "yes";
        font = "Sofia Pro 16";
        line_height = 0;
        markup = "full";
        format = ''<b>%s</b>\n%b'';
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 128;
        max_icon_size = 300;
        always_run_scripts = true;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 15;
        ignore_dbusclose = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "context";
        mouse_right_click = "do_action";
      }; 
      urgency_low = {
        background = "#000000";
        foreground = "#7aa2f7";
        frame_color = "#7aa2f7";
        timeout = 10;
      };
      urgency_normal = {
        background = "#000000";
        foreground = "#7aa2f7";
        frame_color = "#7aa2f7";
        timeout = 10;
      };
      urgency_critical = {
        background = "#000000";
        foreground = "#ad032e";
        frame_color = "#ad032e";
        timeout = 10;
      };
    };
  };
}
