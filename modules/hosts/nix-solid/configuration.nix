{ self, inputs, ... }: {
  flake.nixosModules.nix-solid-conf = { pkgs, lib, config, ... }: {


    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    device-type = "server";


    imports = [
      self.nixosModules.users-n0ll
    ];

  };

}
