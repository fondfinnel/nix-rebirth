# A baseline any derivation is built from, including some custom options.
{ self, inputs, ... }: {

  flake.nixosModules.base = { lib, pkgs, ... }:
    with lib;
    {

      imports = [
        inputs.home-manager.nixosModules.default
        ./opts.nix
      ];


      config = {

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };

    };

}
