# TODO Sync emacs config in a cleaner way between machines
{ self, inputs, config, ... }: {

  flake.homeModules.development = { config, lib, pkgs, ... }: let
    # is emacs daemon or program enabled
    ck = (config.services.emacs.enable || config.programs.emacs.enable);
  in {

    services.emacs = lib.mkDefault {
      enable = true;
      client.enable = config.services.emacs.enable;
    };
    programs.emacs.enable = lib.mkDefault true;
    
    # default to emacs client if enabled, if service unavailable then standalone emacs 
    # managing it via the env var makes it easier to integrate elsewhere (i.e. kitty module)
    home.sessionVariables.EDITOR = lib.mkDefault (lib.mkIf config.services.emacs.enable  "${pkgs.emacs}/bin/emacsclient -nw -c -a ${pkgs.evil-helix}/bin/hx");

    home.packages = with pkgs; lib.mkIf ck [
      ledger
      nil # nix
      # python312Packages.python-lsp-server # python
      markdown-oxide # markdown lsp for notes
      # ruff # python
      # black # python
      nixfmt
      fish-lsp
      clang # c++
      ffmpegthumbnailer # dirvish
      vips # dirvish
      xclip # org-download
      tetex
      ispell
    ];

    xdg.mimeApps.defaultApplications = let x = "emacsclient.desktop"; in lib.mkIf ck {
      "application/xml" = [ x ];
      "text/plain" = [ x ];
      "text/markdown" = [ x ];
      "text/org" = [ x ];
    };

    home.shellAliases.em = lib.mkIf ck config.home.sessionVariables.EDITOR;

    home.preserve.directories = lib.mkIf ck [ ".config/emacs" "org" ];

  };

}
