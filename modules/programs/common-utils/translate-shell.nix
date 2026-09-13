{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.translate-shell.enable = lib.mkDefault true;

  };


}
