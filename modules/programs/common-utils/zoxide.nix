{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.zoxide.enable = lib.mkDefault true;
    home.shellAliases.cd = "z";

    # keep the zoxide database
    home.persistence."/persistent".directories = [
      "${config.xdg.dataHome}/zoxide"
    ];

  };


}
