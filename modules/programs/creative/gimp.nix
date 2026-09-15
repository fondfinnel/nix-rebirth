{ self, inputs, config, ... }: {

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }:  let
    check = osConfig.headless-check;
  in {

    options.programs.gimp.enable = lib.mkEnableOption "gimp";
    config.programs.gimp.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.gimp.enable [ pkgs.gimp ];

  };


}
