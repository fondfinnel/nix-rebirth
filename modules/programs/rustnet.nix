{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.rustnet.enable = lib.mkEnableOption "rustnet";
    config.programs.rustnet.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.rustnet.enable == true) [ pkgs.rustnet ];

    config.home.shellAliases.iftop = "rustnet";

  };


}
