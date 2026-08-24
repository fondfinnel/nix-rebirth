{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: {

    # required for dbus management
    environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    xdg.portal.enable = false;

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
        inputs.nix-index-database.homeModules.default
      ];

    };


  };

  flake.homeModules.base = { osConfig, config, lib, pkgs, ... }: {
    home.stateVersion = lib.mkDefault osConfig.system.stateVersion;

    # inherit user's assigned shell
    home.sessionVariables.SHELL = lib.mkDefault "${osConfig.users.users."${config.home.username}".shell}";

    home.file.".face".source = lib.mkDefault ./tempface.svg;

    programs.nix-index.enable = true;
    home.preserve.directories = [ ".cache/nix-index" ];

    sops = {
      
      defaultSopsFile = lib.mkDefault ./secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = true;

      age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      age.generateKey = true;

    };

    xdg.mimeApps.enable = lib.mkDefault true;
    xdg.portal.enable = lib.mkDefault true;
    xdg.portal.xdgOpenUsePortal = lib.mkDefault false;

    home.packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.trash-cli
    ];

  };

}
