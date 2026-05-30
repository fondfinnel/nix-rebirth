{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.audacity.enable = lib.mkEnableOption "audacity";
    config.programs.audacity.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.audacity.enable [ pkgs.audacity ];

  };


}
