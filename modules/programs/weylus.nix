{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.weylus = { lib, config, pkgs, ... }: {
    
    programs.weylus = {
  	  enable = lib.mkDefault check;
      openFirewall = lib.mkDefault check;
    };

  };


}
