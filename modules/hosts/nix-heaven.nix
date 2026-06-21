{ self, inputs, config, ... }: {

  flake.nixosConfigurations.nix-heaven = inputs.nixpkgs.lib.nixosSystem {
    imports = [
      self.nixosModules.base
      self.nixosModules.nix-heaven-conf
      self.nixosModules.nix-heaven-hw
    ];
  };

  flake.nixosModules.nix-heaven-conf = { lib, config, pkgs, ... }: {

  };

  flake.nixosModules.nix-heaven-hw = { lib, config, pkgs, ... }: {

  };



}
