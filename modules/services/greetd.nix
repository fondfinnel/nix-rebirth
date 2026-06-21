{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.greetd = { lib, pkgs, config, ... }: {
    services.greetd = {

      enable = lib.mkDefault check;
      useTextGreeter = lib.mkDefault true;

      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --sessions ${pkgs.hyprland}/bin/start-hyprland";
        user = config.users.users.n0ll.name;
      };

      # upon boot, immediate default to this session
      settings.initial_session = lib.mkDefault {
          command = "${pkgs.hyprland}/bin/start-hyprland";
          user = config.users.users.n0ll.name;
        };

      };
    };

}
