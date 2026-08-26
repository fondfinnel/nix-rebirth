{ self, inputs, config, ... }: {


  flake.homeModules.common-utils = { lib, ... }: {

    programs.television = {
      enable = lib.mkDefault true;
      settings.keybinds.quit = [
        "ctrl-g"
        "ctrl-g"
        "esc"
      ];
    };

    home.preserve.directories = [
      ".config/television/cable"
    ];

  };


}
