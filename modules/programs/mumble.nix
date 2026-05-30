{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.mumble.enable = lib.mkEnableOption "mumble";
    config.programs.mumble.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.mumble.enable [ pkgs.mumble ];

  };


}
