{ self, inputs, config, ... }: {

  flake.nixosConfigurations.nix-heaven = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-heaven-conf
      self.nixosModules.nix-heaven-hw
      self.nixosModules.users
      self.nixosModules.self-host
    ];
  };

  flake.nixosModules.nix-heaven-conf = { lib, config, pkgs, ... }: {

  };

  flake.nixosModules.nix-heaven-hw = { lib, config, pkgs, ... }: {

  };



}
