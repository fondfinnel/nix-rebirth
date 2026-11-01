# todo Sync emacs config in a cleaner way between machines
{
  self,
  inputs,
  config,
  ...
}:
{

  flake.homeModules.development =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # is emacs daemon or program enabled
      ck = (
        config.services.emacs.enable || config.programs.emacs.enable || config.programs.doom-emacs.enable
      );
      alias = "${pkgs.emacs}/bin/emacsclient -nw -c";
    in
    {

      stylix.targets.emacs.enable = false;

      services.emacs = lib.mkDefault {
        enable = true;
        client.enable = config.services.emacs.enable;
      };
      # programs.emacs.enable = lib.mkDefault config.services.emacs.enable;

      # default to emacs client if enabled, if service unavailable then standalone emacs
      # managing it via the env var makes it easier to integrate elsewhere (i.e. kitty module)
      home.sessionVariables.EDITOR = lib.mkDefault (lib.mkIf config.services.emacs.enable alias);

      home.packages =
        with pkgs;
        lib.mkIf ck [
          ledger
          nil # nix
          # python312Packages.python-lsp-server # python
          markdown-oxide # markdown lsp for notes
          # ruff # python
          # black # python
          git
          coreutils
          fd
          clang
          nixfmt
          fish-lsp
          clang # c++
          ffmpegthumbnailer # dirvish
          vips # dirvish
          xclip # org-download
          tetex
          ispell
          tree-sitter
        ];

      xdg.mimeApps.defaultApplications =
        let
          x = "emacsclient.desktop";
        in
        lib.mkIf ck {
          "application/xml" = [ x ];
          "text/plain" = [ x ];
          "text/markdown" = [ x ];
          "text/org" = [ x ];
        };

      home.shellAliases.em = alias;

      home.preserve.directories = lib.mkIf ck [
        # config dirs
        ".config/emacs"
        ".config/emacs.bak"

        # notes
        "org"
      ];

    };

}
