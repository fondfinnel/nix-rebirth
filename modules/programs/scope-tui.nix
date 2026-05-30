{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.scope-tui.enable = lib.mkEnableOption "scope-tui";
    config.programs.scope-tui.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.scope-tui.enable [ pkgs.scope-tui ];

    config.home.shellAliases.scope = "scope-tui pulse pipewire.monitor";

  };


}
