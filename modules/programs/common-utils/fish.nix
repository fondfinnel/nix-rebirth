{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.fish = {
      enable = lib.mkDefault true;

      # Pull aliases from bash, concat with specific fish aliases
      shellAbbrs = config.home.shellAliases // {
        cm = "command";
        unfree = "export NIXPKGS_ALLOW_UNFREE=1";
      };

      # disabled init due to conflicts in specific cases
      # shellInit = "${config.myAliases.fetch}\n";
      
      functions = {
        fish_greeting = "";
        last_history_item = ''
        echo $history[1]
      '';
      };

      plugins = [
        # { name = "pure"; src = pkgs.fishPlugins.pure.src; } 
        { name = "humantime-fish"; src = pkgs.fishPlugins.humantime-fish.src; }
      ];

    };

  };


}
