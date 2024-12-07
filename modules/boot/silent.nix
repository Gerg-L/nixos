{ lib }:
{
  /*
    Lots taken from here
    https://wiki.archlinux.org/title/Silent_boot
  */
  environment.etc.issue = {
    /*
      Turns the cursor back on in the TTY
      It's the output of this commmand
      setterm -cursor on
    */

    text = "[?12l[?25h";
    mode = "0444";
  };
  boot = {
    kernelParams = lib.mkBefore [
      "fbcon=nodefer" # Wipes the vendor logo earlier
      "vt.global_cursor_default=0" # Stops cursor blinking while booting
      "quiet" # Less log messages
      "systemd.show_status=auto" # Only show systemd errors
      "udev.log_level=3" # Only show udev errors
      "splash" # Show splash
    ];
    consoleLogLevel = 3; # Only errors
    initrd = {
      verbose = false; # Less stage1 messages
      systemd.enable = true; # Use systemd initrd
    };
    # Hide grub (if it's being used)
    loader.grub.extraConfig = ''
      GRUB_TIMEOUT_STYLE=hidden
      GRUB_HIDDEN_TIMEOUT_QUIET=true
    '';
    /*
      Not recommended
      rolling back can be a pain
    */
    #timeout = 0;
  };
}
