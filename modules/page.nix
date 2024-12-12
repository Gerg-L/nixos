{ pkgs, config }:
{
  systemd.tmpfiles.rules = [ "d /tmp/neovim-page 0777 root root - -" ];

  environment = {
    systemPackages = [ pkgs.page ];
    variables = {
      PAGER = "page -WC -q 90000 -z 90000";
      SYSTEMD_PAGERSECURE = "true";
      MANPAGER = "page -t man";
    };
    shellAliases.page = config.environment.variables.PAGER;
  };

  programs.zsh.interactiveShellInit = ''
    man () {
      PROGRAM="''${@[-1]}"
      SECTION="''${@[-2]}"
      page -W "man://$PROGRAM''${SECTION:+($SECTION)}"
    }
  '';

}
