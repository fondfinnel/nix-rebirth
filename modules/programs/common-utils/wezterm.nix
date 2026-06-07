{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {
    
    programs.wezterm = {
      enable = lib.mkDefault false;

      settings.return = lib.mkDefault {
        font = lib.generators.mkLuaInLine ''wezterm.font("Mononoki Nerd Font Mono")'';
        font_size = 12;
        dpi = 96;

        # previous issues in hyprland, disable when hyprland is enabled
        enable_wayland = config.wayland.windowManager.hyprland.enable != true;
      };
    };

  };


}
