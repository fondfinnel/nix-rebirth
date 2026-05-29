{ self, inputs, config, ... }: {

  flake.homeModules.gammastep = { ... }: {
    services.gammastep = {
      enable = config.headless-check;

      temperature.day = 6500;
      temperature.night = 4300;

      duskTime = "19:00-22:00";
      dawnTime = "5:00-6:00";
    };
  };

}
