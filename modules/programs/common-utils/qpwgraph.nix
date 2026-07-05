{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    options.programs.qpwgraph.enable = lib.mkEnableOption "qpwgraph";
    config.programs.qpwgraph.enable = lib.mkDefault osConfig.services.pipewire.enable;

    config.home.packages = lib.mkIf config.programs.qpwgraph.enable [ pkgs.qpwgraph ];

  };


}
