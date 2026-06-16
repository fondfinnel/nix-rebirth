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
 
 
 }
