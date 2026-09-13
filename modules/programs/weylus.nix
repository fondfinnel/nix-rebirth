{ self, inputs, config, ... }: {

  flake.nixosModules.weylus = { lib, config, pkgs, ... }: let
    check = config.headless-check;
  in {
    
    programs.weylus = {
  	  enable = lib.mkDefault check;
      openFirewall = lib.mkDefault check;
    };

  };


}
