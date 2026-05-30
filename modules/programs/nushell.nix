{ self, inputs, config, ... }: {

flake.homeModules.common-utils = { config, lib, ... }: {

  programs.nushell = {
    enable = lib.mkDefault true;

    shellAliases = config.home.shellAliases;

  };

  programs.carapace.enable = lib.mkDefault config.programs.nushell.enable;

};


}
