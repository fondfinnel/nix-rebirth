{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in{

    options.programs.mumble.enable = lib.mkEnableOption "mumble";
    config.programs.mumble.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.mumble.enable [ pkgs.mumble ];

  };


}
