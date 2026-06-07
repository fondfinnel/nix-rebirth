{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {

    services.pipewire = lib.mkDefault {

      enable = check;
      audio.enable = check;
      wireplumber.enable = check;

      # other audio outputs
      alsa.enable = check;
      alsa.support32Bit = check;
      pulse.enable = check;
      jack.enable = check;
    };

    # enable realtime audio
    security.rtkit.enable = lib.mkDefault check;

  };


}
