# A baseline any derivation is built from.
{ self, inputs, ... }: {

  flake.nixosModules.base = { lib, pkgs, config, ... }:
    with lib;
    {

      imports = [
        inputs.home-manager.nixosModules.default
        ./opts.nix
      ];


      config = {

        system.stateVersion = "25.05";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = {
            inherit (self) inputs outputs;
          };

          # every user should have these modules available
          sharedModules = [

            {
              home.stateVersion = "25.05";
            }

          ] ++ lib.optionals (config.device-type == "primary") [

            self.homeModules.sync-drive

          ];

        };

      };

    };

}
