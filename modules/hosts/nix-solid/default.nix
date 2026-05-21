{ self, inputs, ... }: {
  flake.nixosConfigurations.nix-solid = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nix-solid-conf
      self.nixosModules.nix-solid-hw

      self.nixosModules.bluetooth 
      self.nixosModules.base
    ];

  };
}
