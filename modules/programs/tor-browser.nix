{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.tor-browser.enable = lib.mkEnableOption "tor-browser";
    config.programs.tor-browser.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.tor-browser.enable [ pkgs.tor-browser ];

  };


}
