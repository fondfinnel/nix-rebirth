{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.wifitui.enable = lib.mkEnableOption "wifitui";
    config.programs.wifitui.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf (config.programs.wifitui.enable) [ pkgs.wifitui ];

    config.home.shellAliases.nmtui = lib.mkIf config.programs.wifitui.enable "wifitui";

  };


}
