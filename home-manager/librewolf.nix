{
  programs = {
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = true;
        "media.peerconnection.ice.no_host" = false;
        "browser.sessionstore.resume_from_crash" = false;
        "security.OCSP.require" = false;
        "network.dns.disableIPv6" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
      };
    };
  };
}
