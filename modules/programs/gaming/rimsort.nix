{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: {

    options.programs.rimsort.enable = lib.mkEnableOption "rimsort";
    config.programs.rimsort.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.rimsort.enable [ pkgs.rimsort ];

    config.home.preserve.directories = lib.mkIf config.programs.rimsort.enable [ ".local/share/RimSort" ];

  };


}
