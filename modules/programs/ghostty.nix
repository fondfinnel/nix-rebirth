{ self, inputs, config, ... }: {

  flake.homeModules.ghostty = { ... }: {

    programs.ghostty.enable = true;

  };


}
