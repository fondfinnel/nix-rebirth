{ self, inputs, config, ... }: {

  flake.homeModules.mpd = { ... }: {

    services.mpdscribble = {
      enable = true;
    };

  };


}
