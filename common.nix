_: {lib, ...}: {
  #hardware stuff
  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  #sound settings
  security.rtkit.enable = true;
  sound.enable = lib.mkForce false; #disable alsa
  hardware.pulseaudio.enable = lib.mkForce false; #disable pulseAudio
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
    };
    networkmanager.enable = true;
  };
  #enable ssh
  programs = {
    mtr.enable = true; #ping and traceroute
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  #time settings
  time.timeZone = "America/New_York";
  services = {
    timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com"
      ];
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  services.gvfs.enable = true; #gvfs for pcmanfm
}
