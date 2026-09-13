{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.tor-browser.enable = lib.mkEnableOption "tor-browser";
    config.programs.tor-browser.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.tor-browser.enable [ pkgs.tor-browser ];

  };


}
