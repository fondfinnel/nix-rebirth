{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, config, osConfig, lib, ... }: {

    
    programs.oh-my-posh = let
      check = config.home.sessionVariables.SHELL == pkgs.fish;
    in {
      # default when using fish
      enable = lib.mkDefault false;
      useTheme = lib.mkDefault "tiwahu";
      # sonicboom_dark
      # craver
      # pure
      # emodipt-extend
      # microverse-power
      # slim
    };

  };


}
