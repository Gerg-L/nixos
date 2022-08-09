{pkgs, ...}:
{
  services.gvfs.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin];
  };
}
