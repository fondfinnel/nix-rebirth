{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: let
    check = config.wayland.windowManager.hyprland.enable;
  in {

    config.programs.hyprshot.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.hyprshot.enable [ pkgs.hyprshot ];

  };


}
