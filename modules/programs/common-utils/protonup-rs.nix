{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.protonup-rs.enable = lib.mkEnableOption "protonup-rs";
    config.programs.protonup-rs.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.protonup-rs.enable [ pkgs.protonup-rs ];
    config.home.shellAliases.protonup = lib.mkIf config.programs.protonup-rs.enable "protonup-rs";

  };


}
