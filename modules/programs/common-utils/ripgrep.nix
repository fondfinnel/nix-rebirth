{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.ripgrep.enable = lib.mkDefault true;
    programs.ripgrep-all.enable = lib.mkDefault config.programs.ripgrep.enable;
    home.packages = lib.mkIf config.programs.ripgrep.enable [ pkgs.repgrep ];

    home.shellAliases.rg = lib.mkIf config.programs.ripgrep.enable "rg";

  };


}
