{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.gimp.enable = lib.mkEnableOption "gimp";
    config.programs.gimp.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.gimp.enable [ pkgs.gimp ];

  };


}
