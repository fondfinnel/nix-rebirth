{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { config, lib, ... }: {

    programs.ledger = {
      enable = lib.mkDefault false;
      settings = lib.mkIf config.programs.ledger.enable {
        file = [
          "${config.home.homeDirectory}/org/ledger/main.ledger"
        ];
        sort = "date";
      };
    };

    home.preserve.directories = lib.mkIf config.programs.ledger.enable [ "org" ];

  };

}
