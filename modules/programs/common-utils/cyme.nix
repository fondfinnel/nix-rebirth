{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.cyme.enable = lib.mkEnableOption "cyme";
    config.programs.cyme.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.cyme.enable [ pkgs.cyme ];
    config.home.shellAliases.lsusb = lib.mkIf config.programs.cyme.enable "cyme";

  };


}
