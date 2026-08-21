{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, ... }: {

    programs.television.enable = lib.mkDefault true;

    programs.nix-search-tv =
      {
        enable = lib.mkDefault true;

        settings =
          {
            update_interval = "168h";
            indexes =
              [
                "nixpkgs"
                "home-manager"
                "nixos"
                "noogle"
              ];

            render_docs_indexes =
              {
                "preservation" = "https://nix-community.github.io/preservation/configuration-options.html";
              };
            
          };
      };
    
    home.preserve.directories = [ ".cache/nix-search-tv" ]; 

  };

}
