_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    heroic
    legendary-gl
    prismlauncher
  ];
}
