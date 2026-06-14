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


}
