{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.gaming = { lib, pkgs, config, ... }: {

    options.programs.clonehero.enable = lib.mkEnableOption "clonehero";
    config.programs.clonehero.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.clonehero.enable == true) [ pkgs.clonehero ];

    config.home.persistence."/persist".directories = [ "${config.xdg.configHome}/unity3d/srylain Inc_/Clone Hero" ];

  };




}
