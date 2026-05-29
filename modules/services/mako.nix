{ self, inputs, config, ... }: let
  check = config.headless-check;
in {
  flake.homeModules.mako = { lib, pkgs, ... }: {

    services.mako = lib.mkDefault {
      enable = check;

      settings = {
        max-icon-size = "32";
        default-timeout = "5000";
        max-visible = "3";
        width = "300";
        height = "150";
        group-by = "category";
        layer = "overlay";
        font = "${pkgs.nerd-fonts.mononoki} 10";
        border-radius = "5";
        margin = "5";
      };

    };

  };
}
