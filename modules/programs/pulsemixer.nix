{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    # if one of pipewire.pulse or pulseaudio is enabled
    check = osConfig.services.pipewire.pulse.enable != osConfig.services.pulseaudio.enable;
  in {

    options.programs.pulsemixer.enable = lib.mkEnableOption "pulsemixer";
    config.programs.pulsemixer.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.pulsemixer.enable [ pkgs.pulsemixer ];

  };


}
