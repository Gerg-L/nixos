_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    heroic
    legendary-gl
    prismlauncher
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
