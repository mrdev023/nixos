{
  ...
}:

let
  variables = import ../../variables.nix;
  offset.x = toString variables.window.gap;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
        shrink = "yes";
        width = 400;
        height = "(12, 300)";
        offset = "(${offset.x}, 48)";
        origin = "top-right";
        indicate_hidden = "yes";
        padding = variables.window.gap; # Padding top/bottom
        horizontal_padding = variables.window.gap * 2; # Padding left/right
        separator_height = variables.window.border.size;
        frame_width = variables.window.border.size;
        corner_radius = variables.window.border.radius;
        notification_limit = 5;

        # Sort messages by urgency.
        sort = "yes";

        idle_threshold = 120;
        line_height = 5;
        markup = "full";

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %c  category
        #   %S  stack_tag
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value ([ 0%] to [100%])
        #   %n  progress value without any extra characters
        #   %%  literal %
        # Markup is allowed
        format = "<span size='x-large'> </span><b>%s %p</b>\\n%b";

        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = true;
        show_indicators = "yes";
        icon_position = "top";
        max_icon_size = 40;
        sticky_history = "yes";
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";

        # Always run rule-defined scripts, even if the notification is suppressed
        always_run_script = true;

        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
        force_xinerama = false;
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        timeout = 8;
        format = "<span size='x-large'> </span><b>%s %p</b>\\n%b";
      };

      urgency_normal = {
        timeout = 10;
        format = "<span size='x-large'>󰂞 </span><b>%s %p</b>\\n%b";
      };

      urgency_critical = {
        timeout = 0;
        format = "<span size='x-large'>󰵙 </span><b>%s %p</b>\\n%b";
      };
    };
  };
}
