{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.zsh = {
      enable = lib.mkDefault true;
      # initExtra = "${config.myAliases.fetch}\n"; # running command on shell start
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        theme = "trapd00r"; # alts: itchy, jonathan, bira, duellj. complete list https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
        plugins = [
          "colorize"
          "colored-man-pages"
          "command-not-found"
          "fzf"
          "copypath"
          "copyfile"
          "common-aliases"
          "battery"
        ];
      };

    };
    

  };


}
