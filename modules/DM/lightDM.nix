{
  config,
  lib,
  self,
  pkgs,
  ...
}: {
  options.localModules.DM.lightdm.enable = lib.mkEnableOption "";

  config = lib.mkIf config.localModules.DM.lightdm.enable {
    services.xserver = {
      displayManager = {
        lightdm = {
          enable = true;
          background = self.packages.${pkgs.system}.images + /recursion.png;
          extraConfig = "minimum-vt=1";
          greeters.mini = {
            enable = true;
            user = config.localModules.DM.loginUser;
            extraConfig = ''
              [greeter]
              show-password-label = false
              password-label-text =
              invalid-password-text =
              show-input-cursor = false
              password-alignment = center
              password-input-width = 19
              show-image-on-all-monitors = true


              [greeter-theme]
              font = "OverpassMono Nerd Font"
              font-size = 1.1em
              text-color = "#7AA2F7"
              error-color = "#DB4B4B"
              background-color = "#000000"
              window-color = "#000000"
              border-color = "#000000"
              password-character = -1
              password-color = "#7AA2F7"
              password-background-color = "#24283B"
              password-border-color = "#000000"
              password-border-radius = 0.341125em
            '';
          };
        };
      };
    };
  };
}
