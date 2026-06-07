{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {
    
    programs.foot = {
      enable = lib.mkDefault false;
      settings = lib.mkDefault {
        main = {
          dpi-aware = "yes";
          term = "foot";
          font = "Mononoki Nerd Font Mono:size=11";
        };
        mouse.hide-when-typing = "yes";
        colors.alpha = "0.8";
      };
    };

  };


}
