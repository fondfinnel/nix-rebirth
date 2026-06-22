{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { ... }: {
    services.openssh.enable = true;

    environment.preserve.directories = [ "/etc/ssh" ];
  };


  # https://youtu.be/3CeXbONjIgE
  flake.homeModules.common-utils = { pkgs, lib, config, ... }:
    let
      pathToKeys = ../../../keys/${config.home.username};
      keys = lib.lists.forEach (builtins.attrNames (builtins.readDir pathToKeys))
        # remote the .pub
        (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
      publicKeyEntries = lib.attrsets.mergeAttrsList (
        lib.lists.map
          # list of dicts
          (key: { ".ssh/${key}.pub".source = "${pathToKeys}/${key}.pub"; })
          keys
      );
    in {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*" = {
          VisualHostKey = true;
          AddKeysToAgent = true;
          controlPersist = "10m";
        };
      };

      home.file = {
        ".ssh/sockets/keep".text = "# Managed by Home Manager";
      } // publicKeyEntries;

      home.preserve.directories = [ ".ssh" ];

    };


}
