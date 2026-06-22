{ self, inputs, config, ... }: {

  flake.homeModules.development = { pkgs, lib, config, ... }: let d = lib.mkDefault; in {

    programs.git = {

      enable = d true;

      settings = {      
        init.defaultBranch = d "main";
        pull.rebase = d true;
        color.ui = d "auto";
        push.autoSetupRemote = d true;
      };

      settings = lib.mkDefault {
        "${config.home.username}" = {
          name = d config.home.username;
          email = d "";
        };

      };

    };

    programs.lazygit.enable = d true;

    home.shellAliases =  {    
      gca = d "git commit -a";
      gcam = d "git commit -a -m";
      gco = d "git checkout";
      gg = d "lazygit";
    };

  };


}
