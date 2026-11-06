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
      ck = (emacs-ck || config.programs.emacs.enable || doom-ck);
      emacs-ck = config.services.emacs.enable;
      doom-ck = config.programs.doom-emacs.enable;
      alias = "${pkgs.emacs}/bin/emacsclient -nw";
    in

    {

      stylix.targets.emacs.enable = false;

      services.emacs = lib.mkDefault {
        enable = true;
        client.enable = config.services.emacs.enable;
      };
      programs.doom-emacs.enable = lib.mkDefault true;

      # disable standard emacs if doom is enabled
      programs.emacs.enable = if doom-ck then lib.mkForce false else lib.mkDefault emacs-ck;

      # default to emacs client if enabled, if service unavailable then standalone emacs
      # managing it via the env var makes it easier to integrate elsewhere (i.e. kitty module)
      home.sessionVariables.EDITOR = lib.mkIf ck alias;

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
        ".cache/doom"
        ".local/share/doom"
        ".local/state/doom"

        # nix caches packages on build
        # without presisting, it pulls each package repeatedly after reboot
        ".cache/nix"

        # keeping old config around
        # synced to drive, used elsewhere
        ".config/emacs.bak"

        # notes
        "org"
      ];

    };

}
