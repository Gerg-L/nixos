{config, ...}: {
  hardware = {
    nvidia = {
      nvidiaPersistenced = false;
      nvidiaSettings = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
