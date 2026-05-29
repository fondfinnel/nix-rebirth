{ self, inputs, config, ... }: {

  flake.homeModules.walker = { ... }: {

    # config might pull up osConfig at this scope, not sure 
    services.walker = {
      systemd.enable = config.services.walker.enable;
      enableElephantIntegration = config.services.elephant.enable;
    };

    services.elephant.enable = true;

  };

}
