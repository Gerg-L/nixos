_: {
  config,
  options,
  lib,
  ...
}:
with lib; let
  cfg = config.localModules.hardware;
in {
  options.localModules.hardware = {
    gpuAcceleration = {
      disable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    sound = {
      disable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkMerge [
    (
      mkIf (! cfg.gpuAcceleration.disable) {
        hardware.opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      }
    )
    (mkIf (! cfg.sound.disable) {
      security.rtkit.enable = true;
      sound.enable = lib.mkForce false; #disable alsa
      hardware.pulseaudio.enable = lib.mkForce false; #disable pulseAudio
      services.pipewire = {
        enable = true;
        audio.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
      };
    })

    {
      hardware = {
        enableRedistributableFirmware = true;
        cpu = {
          intel.updateMicrocode = true;
          amd.updateMicrocode = true;
        };
      };
    }
  ];
}
