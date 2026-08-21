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
        { name = "pure"; src = pkgs.fishPlugins.pure.src; } 
        { name = "humantime-fish"; src = pkgs.fishPlugins.humantime-fish.src; }
        # { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
        # { name = "you-should-use"; src = pkgs.fishPlugins.fish-you-should-use.src; }
        { name = "fish-bd"; src = pkgs.fishPlugins.fish-bd.src; }
      ];

      shellInit = ''
        set --universal pure_enable_nixdevshell true
        set --universal pure_enable_single_line_prompt true 
        set --universal pure_check_for_new_release false
        set --universal pure_begin_prompt_with_current_directory false
      '';

    };

  };


}
