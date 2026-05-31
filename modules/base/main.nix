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
        nixpkgs.config.allowUnfree = true;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = {
            inherit (self) inputs outputs;
          };

          # every user should have these modules available
          sharedModules = [

            self.homeModules.base

          ] ++ lib.optionals config.headless-check [

            self.homeModules.sync-drive

          ];

        };

      };

    };

  flake.homeModules.base = { osConfig, config, lib, ... }: {
    home.stateVersion = "25.05";
    home.sessionVariables.SHELL = "${osConfig.users.users."${config.home.username}".shell}";
    home.file.".face".source = lib.mkDefault ./tempface.svg;
  };

}
