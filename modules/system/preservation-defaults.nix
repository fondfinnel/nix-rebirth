{ self, inputs, config, ... }: {

  flake.nixosModules.preservation-default = { lib, config, pkgs, ... }: {


    preservation.preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/var/lib/NetworkManager"
        "/var/lib/nixos"
        "/etc/ssh"
      ];
    };

  };

  flake.homeModules.impermanence-default = { ... }: {
    
    home.preserve = {
      
      directories = [
        
        "Videos"
        "Pictures"
        "Music"
        "Documents"
        "Desktop"
        "Public"
        "Templates"
        ".config/nixos"
        
      ];
      
    };


  }
