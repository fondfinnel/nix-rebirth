{ self, inputs, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: let

  in {

    imports = [
      inputs.preservation.nixosModules.default
    ];
    
    options.environment.preserve.directories = lib.mkOption {
      description = "List of directories by string to save in system.";
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    options.environment.preserve.files = lib.mkOption {
      description = "List of paths to files by string to save in system.";
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    config.preservation.enable = lib.mkDefault false;
    config.preservation.preserveAt."/persist" = {

      directories = config.environment.preserve.directories ++ [
        "/etc/nixos"
        "/var/lib/NetworkManager"
        "/var/lib/nixos"
        "/etc/ssh"
      ];

      files = config.environment.preserve.files;


      users = lib.mapAttrs (name: user: {
        files = user.home.preserve.files;
        directories = user.home.preserve.directories;
      }) config.home-manager.users;

    };
  };


  flake.homeModules.base = { lib, ... }: {

    options.home.preserve.directories = lib.mkOption {
      description = "List of directories by string to save in home. Pushed upstream into NixOS.";
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    options.home.preserve.files = lib.mkOption {
      description = "List of paths to files by string to save in home. Pushed upstream into NixOS.";
      type = lib.types.listOf lib.types.str;
      default = [];
    };


    config.home.preserve = {
      
      directories = [
        
        "Desktop"
        "Downloads"
        "Music"
        "Documents"
        "Pictures"
        "Projects"
        "Videos"
        "Templates"
        
      ];
      
    };

  };


}
