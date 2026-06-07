{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.jellyfin-desktop.enable = lib.mkEnableOption "jellyfin-desktop";
    config.programs.jellyfin-desktop.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.jellyfin-desktop.enable == true) [ pkgs.jellyfin-desktop ];


  };

}
