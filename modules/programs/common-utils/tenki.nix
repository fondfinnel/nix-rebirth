{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.tenki.enable = lib.mkEnableOption "tenki";
    config.programs.tenki.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.tenki.enable [ pkgs.tenki ];
    config.home.shellAliases.clock = lib.mkIf config.programs.tenki.enable "tenki --blink-colon";

  };


}
