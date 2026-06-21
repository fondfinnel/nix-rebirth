{ self, inputs, config, ... }: {

  flake.homeModules.walker = { config, lib, ... }: {

    services.walker = {
      enable = lib.mkDefault true;
      systemd.enable = config.services.walker.enable;
      enableElephantIntegration = config.services.elephant.enable;
    };

    services.elephant.enable = lib.mkDefault config.services.walker.enable;
    # see https://github.com/basecamp/omarchy/issues/5260#issuecomment-4226493629
    wayland.windowManager.hyprland.settings.env = [ "GSK_RENDERER,cairo" ];

  };

}
