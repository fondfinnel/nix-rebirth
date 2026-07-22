{ self, inputs, config, ... }: {

flake.homeModules.development = { lib, config, ... }: {

  programs.delta = {
    enable = lib.mkDefault true;
    enableGitIntegration = lib.mkDefault config.programs.git.enable;
    enableJujutsuIntegration = lib.mkDefault config.programs.jujutsu.enable;
  };

};


}
