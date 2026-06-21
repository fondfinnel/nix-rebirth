{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, ... }: {

    programs.nh = {
      enable = lib.mkDefault true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 5";
      clean.dates = "daily";
      flake = "/home/n0ll/.config/nix-rebirth/";
    };

    home.shellAliases.ns = "nh search";

  };


}
