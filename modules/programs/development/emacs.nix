# TODO Sync emacs config in a cleaner way between machines
{ self, inputs, config, ... }: {

  flake.homeModules.development = { config, lib, pkgs, ... }: {

    services.emacs = lib.mkDefault {
      enable = true;
      client.enable = config.services.emacs.enable;
    };
    
    # default to emacs client if enabled, if service unavailable then standalone emacs 
    # managing it via the env var makes it easier to integrate elsewhere (i.e. kitty module)
    home.sessionVariables.EDITOR = if config.services.emacs.enable
                                   then lib.mkDefault "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs"
                                   else lib.mkDefault null;

    home.packages = with pkgs; lib.mkIf config.services.emacs.enable [
      ledger
      nil # nix
      python312Packages.python-lsp-server # python
      markdown-oxide # markdown lsp for notes
      ruff # python
      black # python
      fish-lsp
      clang # c++
      ffmpegthumbnailer # dirvish
      vips # dirvish
      xclip # org-download
    ];

    xdg.mimeApps.defaultApplications = let x = "emacsclient.desktop"; in {
      "application/xml" = [ x ];
      "text/plain" = [ x ];
      "text/markdown" = [ x ];
      "text/org" = [ x ];
    };

    programs.bash.shellAliases.em = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs -nw";

  };

}
