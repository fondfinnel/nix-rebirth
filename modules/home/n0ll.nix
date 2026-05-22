{ self, inputs, osConfig, ... }: {

  flake.homeConfigurations.n0ll = inputs.home-manager.lib.homeManagerConfiguration {
    # use architecture from system
    pkgs = import inputs.nixpkgs { system = osConfig.nixpkgs.hostPlatform; };

    
    modules = with self.homeModules; [
      n0ll-conf
    ];
  };

  flake.homeModules.n0ll-conf = { ... }: {

    imports = [
      self.homeModules.hyprland
    ];

    wayland.windowManager.hyprland.enable = true;
  };
}
