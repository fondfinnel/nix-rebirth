{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.fd = {      
      enable = lib.mkDefault true;

      ignores = [
        ".git/"
        "*.bak"
      ];
    };

    home.shellAliases.find = lib.mkDefault "fd";
  };


}
