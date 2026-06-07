{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: let
      check = config.services.pipewire.enable;
  in{

    options.programs.wiremix.enable = lib.mkEnableOption "wiremix";
    config.programs.wiremix.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.wiremix.enable [ pkgs.wiremix ];
    config.home.shellAliases.mixer = lib.mkIf check "wiremix";

  };


}
