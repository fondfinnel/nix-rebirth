{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.nixosModules.base = { lib, config, pkgs, ... }: {

    services.openssh.enable = lib.mkDefault true;
    services.envfs.enable = lib.mkDefault check;

    security.polkit.enable = true;
    security.polkit.adminIdentities = [ "unix-group:wheel" ];
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = true;

      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile = "/var/lib/sops-nix/key.txt";
      age.generateKey = true;
    };

    environment.preserve.files = [ "/var/lib/sops-nix/key.txt" ] ++ config.sops.age.sshKeyPaths;
    
  };


}
