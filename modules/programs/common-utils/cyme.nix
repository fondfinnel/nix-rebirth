{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, ... }: {

    options.programs.cyme.enable = lib.mkEnableOption "cyme";
    config.programs.cyme.enable = lib.default true;

    config.home.packages = [ pkgs.cyme ];
    config.home.shellAliases.lsusb = "cyme";

  };


}
