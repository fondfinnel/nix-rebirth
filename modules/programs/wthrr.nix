{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.wthrr.enable = lib.mkEnableOption "wthrr";
    config.programs.wthrr.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.wthrr.enable [ pkgs.wthrr ];
    config.xdg.configFile."weathercrab/wthrr.ron" = {
      enable = config.programs.wthrr.enable;
      text = ''
      (
        address: "Pittsburgh,US",
        language: "en_US",
        forecast: [day, week],
        units: (
            temperature: fahrenheit,
            speed: mph,
            time: am_pm,
            precipitation: inch,
        ),
        gui: (
            border: solid,
            color: default,
            graph: (
                style: dotted,
                rowspan: single,
                time_indicator: true,
            ),
            greeting: false,
          ),
        )
      '';
    };

  };


}
