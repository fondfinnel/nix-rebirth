{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, pkgs, ... }: {

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

            experimental.render_docs_indexes =
              {
                # "preservation" = "https://nix-community.github.io/preservation/configuration-options.xhtml";
              };
            
          };
      };
    
    home.preserve.directories = [ ".cache/nix-search-tv" ]; 

    home.shellAliases.nst = lib.mkDefault "${pkgs.television}/bin/tv nix-search-tv";

  };

}
