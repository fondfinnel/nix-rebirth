{ self, inputs, ... }: {

  flake.homeModules.sync-drive = { pkgs, ... }: {

    home.packages = let

      unison = "${pkgs.unison}/bin/unison";
      computer-dir = "/home/n0ll";
      flashdrive-dir = "/run/media/n0ll/6FECBB571E13A6FA";

    in [(pkgs.writeShellScriptBin "sync-drive" /*bash*/
      ''

        # check if flash drive is available
        if [ ! -e ${flashdrive-dir} ]; then
                echo -e 'Fuck you! 󰜺 '
                exit
            fi

        echo -e '\nsyncing pass!\n'
        ${unison} -auto -fat -batch -fastcheck=false "${computer-dir}/Keepass/" "${flashdrive-dir}/Keepass/" &&

        echo -e '\nsyncing emacs!\n'
        ${unison} -auto -fat -batch -fastcheck=false "${computer-dir}/.config/emacs.bak/" "${flashdrive-dir}/.config/emacs/" \
            -ignore 'Name .git' \
            -ignore 'Name .cache' \
            -ignore 'Name .Trash-1000' \
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
            -ignore 'Name elpa' \
            -ignore 'Name elpaca' \
            -ignore 'Name undo-fu-session' \
            -ignore 'Name org-persist' \
            -ignore 'Name recentf' \
            -ignore 'Name history' \
            -ignore 'Name bookmarks' \
            -ignore 'Name org-roam.db'&&

        echo -e '\nsyncing org!\n'
        ${unison} -auto -fat -batch -fastcheck=false "${computer-dir}/org/" "${flashdrive-dir}/org/" \
            -ignore 'Name .Trash-1000' \
            -ignore 'Name .git' \
            -ignore 'Name .github' \
            -ignore 'Name .stfolder' \
            -ignore 'Name .stversions' \
            -ignore 'Name .org\~' \
            -ignore 'Name .org\#' &&

        echo -e 'done!'

        # echo -e 'restarting emacs'
        # systemctl restart --user emacs
    '')];

    # required for default unison dir
    # otherwise, unison complains about it being a fresh install
    home.preserve.directories = [ ".unison" ];

  };
}
