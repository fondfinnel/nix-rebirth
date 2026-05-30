{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.yazi = {
      enable = lib.mkDefault true;
      settings = lib.mkDefault {
        mgr = {
          sort_by = "natural";
          sort_sensitive = false;
          sort_dir_first = true;
          sort_translit = true;
          linemode = "size";
          show_hidden = true;
        };
        # Trying to set custom open prompt options
        # No success yet
        # 
        # opener = {
        #   trimmer = { run = "video-trimmer $@"; orphan = true; for = "unix"; };
        #   exif = { run = "exiftool $@"; block = true; for = "unix"; };
        # };
        # open = {
        #   rules = [
        #     { mime = "video/*"; use = [ "play" "trimmer" "exif" ];} 
        #   ];
        # };
      };
      initLua = ''
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
      keymap = {
        mgr.prepend_keymap = [
          {on = [ "<S-t>" ]; run = "plugin --- @sync max-preview"; desc = "Maximize or restore preview";}
          { on = [ "<C-m>" ]; run = ''shell '${pkgs.dragon-drop}/bin/dragon-drop -x -i -T "$1"' --confirm''; desc = "Use dragon for drag-and-drop";}
          { on = ["y"]; run = [''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'' "yank"];} # On yank copy to the system clipboard as well.
          # https://yazi-rs.github.io/docs/tips/#selected-files-to-clipboard
        ];
      };
    };
    # Hoping this concats in the future. Allows Yazi to drop into the active directory when exiting. 
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
