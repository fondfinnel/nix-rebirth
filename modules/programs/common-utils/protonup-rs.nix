{ self, inputs, config, ... }:{

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }:  let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.protonup-rs.enable = lib.mkEnableOption "protonup-rs";
    config.programs.protonup-rs.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.protonup-rs.enable [ pkgs.protonup-rs ];
    config.home.shellAliases.protonup = lib.mkIf config.programs.protonup-rs.enable "protonup-rs";

  };


}
