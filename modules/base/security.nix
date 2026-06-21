{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.nixosModules.base = { lib, config, pkgs, ... }: {

    services.openssh.enable = lib.mkDefault true;
    services.openssh.authorizedKeysInHomedir = true;
    services.envfs.enable = lib.mkDefault check;

    security.polkit.enable = true;
    security.polkit.adminIdentities = [ "unix-group:wheel" ];
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = true;

      age.sshKeyPaths = if
        config.preservation.enable then [ "/persist/etc/ssh/ssh_host_ed25519_key" ]
        else [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile = if config.preservation.enable then "/persist/var/lib/sops-nix/key.txt"
                    else "/var/lib/sops-nix/key.txt";
      age.generateKey = true;
    };

    environment.preserve.directories = [
      config.sops.age.keyFile          
    ] ++ config.sops.age.sshKeyPaths;
    
  };


}
