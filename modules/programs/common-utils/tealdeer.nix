{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, config, ... }: {

    programs.tealdeer = {
      enable = lib.mkDefault true;

      settings = {
        display.compact = true;
        updates.auto_update = true;
      };
    };

    home.preserve.directories = lib.mkIf config.programs.tealdeer.enable [ ".cache/tealdeer" ];

  };


}
