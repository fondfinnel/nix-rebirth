{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.davinci-resolve.enable = lib.mkEnableOption "davinci-resolve";
    config.programs.davinci-resolve.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.davinci-resolve.enable [ pkgs.davinci-resolve ];

  };


}
