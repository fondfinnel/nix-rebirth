{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { config, lib, ... }: {

    programs.nix-search-tv.enable = lib.mkDefault true;
    programs.fzf.enable = lib.mkDefault config.programs.nix-search-tv.enable;

  };


}
