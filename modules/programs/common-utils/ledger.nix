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

    home.preserve.files = lib.mkIf config.programs.ledger.enable config.programs.ledger.settings.file;

  };

}
