{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.yazi = {
      enable = lib.mkDefault true;

      
      shellWrapperName = lib.mkDefault "y";
      settings = lib.mkDefault {

        mgr = {
          sort_by = "natural";
          sort_sensitive = false;
          sort_dir_first = true;
          sort_translit = true;
          linemode = "size";
          show_hidden = true;
        };
        tasks.image_alloc = 1073741824; # 1024MB

        plugin =
          let prep = [
                # Replace magick; image; video with mediainfo
                { mime = "{audio;video;image}/*"; run = "mediainfo"; }
                { mime = "application/subrip"; run = "mediainfo"; }

                # Adobe Photoshop is image/adobe.photoshop; already handled above
                # Adobe Illustrator
                { mime = "application/postscript"; run = "mediainfo"; }
                { mime = "application/illustrator"; run = "mediainfo"; }
                { mime = "application/dvb.ait"; run = "mediainfo"; }
                { mime = "application/vnd.adobe.illustrator"; run = "mediainfo"; }
                { mime = "image/x-eps"; run = "mediainfo"; }
                { mime = "application/eps"; run = "mediainfo"; }

                # Sometimes AI file is recognized as "application/pdf". Lmao.
                # In this case use file extension instead:
                { url = "*.{ai;eps;ait}"; run = "mediainfo"; }

                # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
                # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
              ];
          in {
            prepend_preloaders = prep;
            prepend_previewers = prep;
          };

      };

      initLua = lib.mkDefault ''
        function Linemode:size_and_mtime()
        local year = os.date("%Y")
        local time = math.floor(self._file.cha.modified or 0)
        if time > 0 and os.date("%Y", time) == year then
          time = os.date("%b %d %H:%M", time)
        else
          time = time and os.date("%b %d  %Y", time) or ""
        end
        local size = self._file:size()
        return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
      end
    '';


      plugins = with pkgs.yaziPlugins; lib.mkDefault {
        clipboard = clipboard;
        drag = drag;  # may need to install ripdrag externally

        full-border.package = full-border;
        # full-border.setup = true;

        jjui = jjui;
        recycle-bin = recycle-bin;
        convert = convert;
        compress = compress;
        mount = mount;

        mediainfo = mediainfo;
        time-travel = time-travel;
        toggle-pane = toggle-pane;

        kdeconnect-send.package = kdeconnect-send;
        kdeconnect-send.setup = true;
        kdeconnect-send.settings.auto_select_single = false;

        yafg = yafg;

        yatline.package = yatline;
        yatline.setup = true;

      };

      keymap.mgr.prepend_keymap = lib.mkDefault [

        { on = "T"; run = "plugin toggle-pane max-preview"; desc = "Toggle preview maximize"; }

        { on = [ "z" "h" ]; run = "plugin time-travel prev"; desc = "Go to previous snapshot"; }
        { on = [ "z" "l" ]; run = "plugin time-travel next"; desc = "Go to next snapshot"; }
        { on = [ "z" "h" ]; run = "plugin time-travel exit"; desc = "Exit viewing snapshot"; }

        { on = "y"; run = [ "yank" "plugin clipboard -- --action=copy" ]; desc = "Copy to system clipboard"; }
        { on = "<C-p>"; run = "plugin clipboard -- --action=paste"; desc = "Paste from system clipboard"; }

        { on = "<C-m>"; run = "plugin drag"; desc = "Drag and drop"; }
        { on = [ "g" "j"]; run = "plugin jjui"; desc = "Run jjui"; } 

        { on = [ "g" "o" ]; run = "plugin recycle-bin"; desc = "Open recycle-bin"; } 

        { on = [ "C" "p" ]; run = "plugin convert -- --extension='png'"; desc = "Convert to png"; } 
        { on = [ "C" "j" ]; run = "plugin convert -- --extension='jpg'"; desc = "Convert to jpg"; } 
        { on = [ "C" "w" ]; run = "plugin convert -- --extension='webp'"; desc = "Convert to webp"; } 

        { on = [ "c" "a" ]; run = "plugin compress"; desc = "Compress"; } 
        { on = [ "c" "p" ]; run = "plugin compress -p'"; desc = "Compress with password"; } 

        { on = "M"; run = "plugin mount"; desc = "View mounts"; }

        { on = "<C-s>"; run = "plugin kdeconnect-send"; desc = "Send file(s) via KDE Connect"; }

        { on = "Z"; run = "plugin yafg"; desc = "Search via fzf"; }
        
      ];

    };
    # Allows Yazi to drop into the active directory when exiting. 
    programs.zsh.envExtra = ''
      function yy() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
       		builtin cd -- "$cwd"
        fi
    	  rm -f -- "$tmp"
      }
      '';

  };


}
