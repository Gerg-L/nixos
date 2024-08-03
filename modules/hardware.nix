{ config, lib }:
let
  cfg = config.local.hardware;
in
{
  options.local.hardware = {
    gpuAcceleration.disable = lib.mkEnableOption "";
    sound.disable = lib.mkEnableOption "";
  };
  config = lib.mkMerge [
    (lib.mkIf (!cfg.gpuAcceleration.disable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })
    (lib.mkIf (!cfg.sound.disable) {
      security.rtkit.enable = true;
      hardware.pulseaudio.enable = lib.mkForce false; # disable pulseAudio
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = false;
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
