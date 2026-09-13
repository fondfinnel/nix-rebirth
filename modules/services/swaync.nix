{ self, inputs, config, ... }: {

  flake.homeModules.swaync = { lib, osConfig, ... }: let
    headless-check = osConfig.headless-check;
  in {

    services.swaync = {
      enable = headless-check;
      settings = lib.mkDefault {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        notification-inline-replies = true;
        notification-icon-size = 24;
        timeout = 3;
        timeout-low = 1;
        timeout-critical = 0;
        notification-window-width = 300;
        fit-to-screen = false;
        control-center-width = 400;
        transition-time = 100;
        hide-on-clear = true;
        control-center-positionX = "right";
        control-center-positionY = "top";
        control-center-margin-right = 6;
        control-center-margin-top = 6;
        layer-shell = true;

        widgets = [
          "title"
          "dnd"
          # "mpris"
          "notifications"
        ];
      };
    };

  };

}
