{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.lsd = {
      enable = lib.mkDefault true;

      settings = lib.mkDefault {
        date = "relative";
        color.when = "auto";
        layout = "tree";
        size = "short";
        recursion.enabled = true;
        recursion.depth = 1;
        sorting.dir-grouping = "first";
        total-size = true;
        hyperlink = "auto";
      };
    };

    home.shellAliases.l = "${pkgs.lsd}/bin/lsd";

  };


}
