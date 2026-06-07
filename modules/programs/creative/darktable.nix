{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.darktable.enable = lib.mkEnableOption "darktable";
    config.programs.darktable.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.darktable.enable == true) [ pkgs.darktable pkgs.exiftool ];

  };


}
