{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      backupFileExtension = "backup";
      overwriteBackup = true;

      extraSpecialArgs = {
        inherit (self) inputs outputs;
      };

      # every user should have these modules available
      sharedModules = [

        self.homeModules.base

        inputs.sops-nix.homeManagerModules.sops

      ] ++ lib.optionals config.headless-check [

        self.homeModules.sync-drive

      ];

    };


  };

  flake.homeModules.base = { osConfig, config, lib, ... }: {
    home.stateVersion = lib.mkDefault osConfig.system.stateVersion;

    # inherit user's assigned shell
    home.sessionVariables.SHELL = lib.mkDefault "${osConfig.users.users."${config.home.username}".shell}";

    home.file.".face".source = lib.mkDefault ./tempface.svg;

  };

}
