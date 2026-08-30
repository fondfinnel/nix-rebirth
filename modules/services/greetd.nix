{ self, inputs, config, ... }: {

  flake.nixosModules.greetd = { lib, pkgs, config, ... }: let
    check = config.headless-check;
  in {

    # something keeps enabling regreet
    # services.displayManager.regreet.enable = lib.mkForce false;
    services.greetd = {

      enable = lib.mkDefault true;
      useTextGreeter = lib.mkDefault true;

      settings.default_session = lib.mkIf check {
        command = lib.mkDefault "${pkgs.tuigreet}/bin/tuigreet --time --sessions ${pkgs.hyprland}/bin/start-hyprland";
        # user = lib.mkDefault config.users.users.n0ll.name;
      };

      # upon boot, immediate default to this session
      settings.initial_session = lib.mkIf check {
        command = lib.mkDefault "${pkgs.hyprland}/bin/start-hyprland";
        user = lib.mkDefault config.users.users.n0ll.name;
      };

    };
  };

}
