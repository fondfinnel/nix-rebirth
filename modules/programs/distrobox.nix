{ self, inputs, config, ... }: {

  flake.homeModules.distrobox = { pkgs, config, lib, ... }: {

    programs.distrobox = {
      enable = true;
    };

    home.packages = [ pkgs.distrobox-tui ];

    services.podman.enable = lib.mkDefault config.programs.distrobox.enable;

  };


}
