{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.dvgrab.enable = lib.mkEnableOption "dvgrab";
    config.programs.dvgrab.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.dvgrab.enable [ pkgs.dvgrab ];

  };


}
