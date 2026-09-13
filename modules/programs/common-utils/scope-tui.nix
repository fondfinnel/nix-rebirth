{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = (osConfig.headless-check && osConfig.services.pipewire.enable);
  in {

    options.programs.scope-tui.enable = lib.mkEnableOption "scope-tui";
    config.programs.scope-tui.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.scope-tui.enable [ pkgs.scope-tui ];

    config.home.shellAliases.scope = "scope-tui pulse pipewire.monitor";

  };


}
