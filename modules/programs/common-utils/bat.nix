{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: let
    check = config.programs.bat.enable;
  in {

    programs.bat = {
      enable = lib.mkDefault true;

      extraPackages = with pkgs.bat-extras; [
        batman # man pages
        batwatch # watch output
        batgrep # ripgrep
        batdiff # diff log
      ];
    };

    home.shellAliases = lib.mkIf check {
      cat = "bat";
      man = "batman";
      watch = "batwatch";
      grep = "batgrep";
      rg = "batgrep";
      diff = "batdiff";
    };

    programs.jujutsu.settings.ui.pager = lib.mkIf check ["bat"];

  };


}
