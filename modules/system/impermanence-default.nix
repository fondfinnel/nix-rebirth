 { self, inputs, config, ... }: {
 
   flake.nixosModules.impermanence-default = { lib, config, pkgs, ... }: {
 
 
     environment.persistence."/persistent" = {
       directories = [
         "/etc/nixos"
         "/var/lib/NetworkManager"
         "/var/lib/nixos"
         "/etc/ssh"
       ];
     };
 
   };
 
   flake.homeModules.impermanence-default = { ... }: {
 
     home.persistence."/persistent" = {
 
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
       
   };
 
 
 }
