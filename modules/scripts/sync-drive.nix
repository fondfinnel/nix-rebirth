{ self, inputs, ... }: {

  flake.homeModules.sync-drive = { pkgs, ... }: { 

    home.packages = let
      unison = "${pkgs.unison}/bin/unison";
    in [(pkgs.writeShellApplication "sync-drive" /*bash*/ ''

      # check if flash drive is available
      if [ ! -e /dev/disk/by-uuid/5839-5F7F ]; then
        echo -e 'Fuck you! 󰜺 '
        exit
      fi

      flashdrive="/run/media/n0ll/5839-5F7F/"
      computer="/home/n0ll"

      # Actually sync!
      echo -e '\nsyncing pass!\n'      
      ${unison} -auto -fat -batch -fastcheck=false "$computer/Keepass/" "$flashdrive/Keepass/" &&

      # echo -e '\nsyncing notes!\n'
      # ${unison} -auto -fat -batch -fastcheck=false "$computer/logseq/" "$flashdrive/logseq/" \
      #   -ignore 'Name .smart-env' \
      #   -ignore 'Name .smart-connections' \
      #   -ignore 'Name .stfolder' \
      #   -ignore 'Name .stversions' \
      #   -ignore 'Name .trash' \
      #   -ignore 'Name .obsidian/workspace.json' \
      #   -ignore 'Name .obsidian/plugins/various-complements/histories.json' \
      #   -ignore 'Name .obsidian/plugins/text-extractor/cache/*' &&

      echo -e '\nsyncing emacs!\n'
      ${unison} -auto -fat -batch -fastcheck=false "$computer/.config/emacs/" "$flashdrive/.config/emacs/" \
        -ignore 'Name .cache' \
        -ignore 'Name eln-cache' \
        -ignore 'Name recentf-save.el' \
        -ignore 'Name var/org/persist' \
        -ignore 'Name var/ac-comphist.el' \
        -ignore 'Name var/url' \
        -ignore 'Name var/elfeed/db' \
        -ignore 'Name config.el' \
        -ignore 'Name savehist.el' \
        -ignore 'Name project-list.el' \
        -ignore 'Name ac-comphist.el' \
        -ignore 'Name elpa/archives' \
        -ignore 'Name org-roam.db'&&

        
      echo -e '\nsyncing org!\n'
      ${unison} -auto -fat -batch -fastcheck=false "$computer/org/" "$flashdrive/org/" \
        -ignore 'Name .stfolder' \
        -ignore 'Name .stversions' \
        -ignore 'Name .org\~' \
        -ignore 'Name .org\#' &&

      echo -e 'done!'
      echo -e 'restarting emacs'

      systemctl restart --user emacs

           '')];

  };
}
