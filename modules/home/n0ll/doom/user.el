(setq package-install-upgrade-built-in t)
    ; magit conflicting with org-mode detection... for some reason?
  (setq magit-auto-revert-mode nil)
(setq inhibit-startup-screen t)
(when (eq system-type 'gnu/linux)
  (setq shell-file-name "/run/current-system/sw/bin/sh")
  )

(display-line-numbers-mode)
(prefer-coding-system 'utf-8-unix)

(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(set-face-attribute 'default nil :height 92)

                                        ; automatically create missing directories
                                        ; https://emacsredux.com/blog/2022/06/12/auto-create-missing-directories/
(defun er-auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'er-auto-create-missing-dirs)

(with-eval-after-load 'marginalia
  (setq marginalia-annotators
        (delq 'marginalia-annotate-time marginalia-annotators)))

  ;; (setq use-package!-always-ensure t)

    (require 'package)
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
    ; (package-initialize)
    (package-refresh-contents)

  ;; auto-save-mode doesn't create the path automatically!
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

  ;; Uncomment the following if you are using undo-fu
(setq evil-undo-system 'undo-fu)

;; Vim emulation
(use-package! evil
  :demand t
  :custom
  ;; Make :s in visual mode operate only on the actual visual selection
  ;; (character or block), instead of the full lines covered by the selection
  (evil-ex-visual-char-range t)
  ;; Use Vim-style regular expressions in search and substitute commands,
  ;; allowing features like \v (very magic), \zs, and \ze for precise matches
  (evil-ex-search-vim-style-regexp t)
  ;; Enable automatic horizontal split below
  (evil-split-window-below t)
  ;; Enable automatic vertical split to the right
  (evil-vsplit-window-right t)
  ;; Disable echoing Evil state to avoid replacing eldoc
  (evil-echo-state nil)
  ;; Do not move cursor back when exiting insert state
  (evil-move-cursor-back nil)
  ;; Make `v$` exclude the final newline
  (evil-v$-excludes-newline t)
  ;; Allow C-h to delete in insert state
  (evil-want-C-h-delete t)
  ;; Enable C-u to delete back to indentation in insert state
  (evil-want-C-u-delete t)
  ;; Enable fine-grained undo behavior
  (evil-want-fine-undo t)
  ;; Disable wrapping of search around buffer
  (evil-search-wrap nil)
  ;; Whether Y yanks to the end of the line
  (evil-want-Y-yank-to-eol t)

  :init
  (setq evil-want-keybinding nil)
  :config
  ;; Occasionally, `evil' fails to respect `evil-search-module' when it is
  ;; defined inside the :custom block. This fix ensures the search module
  ;; is correctly set to `evil-search'.
  (setq evil-want-integration t)
  (setq evil-search-module 'evil-search)
  (evil-select-search-module 'evil-search-module 'evil-search)
  (evil-mode 1)
  )

(use-package! evil-collection
  :after evil
  :config
  ;; It has to be defined before evil-collection
  (setq evil-collection-setup-minibuffer t)
  (evil-collection-init)
  )

;; The goto-chg package is useful with Evil to jump directly to the most recent
;; edit location. This mirrors Vim's change navigation, allowing fast return to
;; where text was last modified without relying on the jump list or search.
;;
;; The goto-chg commands are bound to g; and g,
(use-package! goto-chg
  :commands (goto-last-change
             goto-last-change-reverse))

(use-package! evil-goggles
  ;; :ensure t
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))

(use-package! general
  :demand t
  :after evil
  :init
  (general-evil-setup)
  (general-auto-unbind-keys)
  (general-override-mode)
  ;; :config
  (general-create-definer keyb/leader-key
    :keymaps 'override
    :states '(insert emacs normal hybrid motion visual operator)
    :prefix "SPC"
    :non-normal-prefix "s-SPC")
  (keyb/leader-key
    "b" 'consult-buffer
                                        ;window splitting
    "w" '(cons "window-management"(make-sparse-keymap))
    "ww" '(evil-window-next :wk "switch to next")
    "ws" '(evil-window-split :wk "split down")
    "wv" '(evil-window-vsplit :wk "split right")
    "wh" '(evil-window-left :wk "move left")
    "wj" '(evil-window-down :wk "move down")
    "wk" '(evil-window-up :wk "move up")
    "wl" '(evil-window-right :wk "move right")
    "wd" '(evil-window-delete :wk "close")

                                        ; layer for quick toggles on minor mods
    "m" '(cons "minor-modes" (make-sparse-keymap))
    "ms" 'surround-insert
    "f" 'find-file

    "\\" '(avy-goto-char :wk "jump to character")
    "p" 'org-rich-yank

    "d" '(dirvish-dwim :wk "file manager")

                                        ; projects
    "g" '(cons "project management"(make-sparce-keymap))
    "gw" '(projectile-persp-switch-project :wk "open project")
    "gs" '(persp-switch-quick :wk "switch projects")
    "gb" '(persp-switch-to-buffer* :wk "switch to buffer in current project")
    "gf" '(projectile-find-file :wk "projectile")
    "/" '(consult-ripgrep :wk "ripgrep")

                                        ; agenda
    "a" 'org-agenda
    "A" '(cons "org-agenda-alt" (make-sparse-keymap))
    "Ah" '(org-habit-stats-view-habit-at-point :wk "habit stats (org)")
    "AH" '(org-habit-stats-view-habit-at-point-agenda :wk "habit stats (agenda)")
    "As" '(org-timeblock :wk "open timeblock")
    "Ac" '(calfw-org-open-calendar :wk "open calendar")

                                        ; org
    "n" (cons "org-roam" (make-sparse-keymap))

    ))

    (use-package! which-key

        :init
        (which-key-mode)
        :config
        (which-key-setup-side-window-bottom)
    )

;; The flyspell package is a built-in Emacs minor mode that provides
;; on-the-fly spell checking. It highlights misspelled words as you type,
;; offering interactive corrections. In text modes, it checks the entire buffer,
;; while in programming modes, it typically checks only comments and strings. It
;; integrates with external spell checkers like aspell, hunspell, or
;; ispell to provide suggestions and corrections.
;;
;; NOTE: flyspell-mode can become slow when using Aspell, especially with large
;; buffers or aggressive suggestion settings like --sug-mode=ultra. This
;; slowdown occurs because Flyspell checks words dynamically as you type or
;; navigate text, requiring frequent communication between Emacs and the
;; external Aspell process. Each check involves sending words to Aspell and
;; receiving results, which introduces overhead from process invocation and
;; inter-process communication.
(use-package! ispell
  :ensure nil
  :commands (ispell ispell-minor-mode)
  :init
  (setq ispell-quietly t)

  ;; Set the ispell program name to aspell
  (setq ispell-program-name "aspell")

  ;; Define the "en_US" spell-check dictionary locally, telling Emacs to use
  ;; UTF-8 encoding, match words using alphabetic characters, allow apostrophes
  ;; inside words, treat non-alphabetic characters as word boundaries, and pass
  ;; -d en_US to the underlying spell-check program.
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))

  ;; Configures Aspell's suggestion mode to "ultra", which provides more
  ;; aggressive and detailed suggestions for misspelled words. The language
  ;; is set to "en_US" for US English, which can be replaced with your desired
  ;; language code (e.g., "en_GB" for British English, "de_DE" for German).
  (setq ispell-extra-args '("--sug-mode=ultra"
                            "--lang=en_US"
                            ;; The --run-together flag instructs Aspell to accept
                            ;; words formed by combining two or more valid dictionary
                            ;; words without spaces, treating the resulting string as
                            ;; valid.
                            ;;
                            ;; This is excellent for source code. Code is heavily
                            ;; populated with compound variable names and technical
                            ;; terms (e.g., filepath, buffername, checkbox). This
                            ;; flag stops the spell checker from highlighting every
                            ;; combined word as an error, significantly reducing
                            ;; false positives and visual noise in your programming
                            ;; buffers.
                            "--run-together"))


  (defun my-ispell-text-mode-setup ()
    "Remove the --run-together argument from Aspell in text modes."
    (setq-local ispell-extra-args (remove "--run-together" ispell-extra-args)))

  (add-hook 'text-mode-hook #'my-ispell-text-mode-setup))

;; The flyspell package is a built-in Emacs minor mode that provides
;; on-the-fly spell checking. It highlights misspelled words as you type,
;; offering interactive corrections.
(use-package! flyspell
  :ensure nil
  :commands flyspell-mode
  :hook
  ((prog-mode . flyspell-prog-mode)
   (text-mode . (lambda()
                  (if (or (derived-mode-p 'yaml-mode)
                          (derived-mode-p 'yaml-ts-mode)
                          (derived-mode-p 'ansible-mode))
                    (flyspell-mode 1))))))

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.

(use-package! undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  )

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package! undo-fu-session
  :init
  (undo-fu-session-global-mode 1))
:config
(with-eval-after-load 'evil (setopt evil-undo-system 'undo-fu))

;; better binds for evil
; (define-key evil-normal-state-map "u" #'undo-fu-only-undo)
; (define-key evil-normal-state-map "U" #'undo-fu-only-redo)
; (define-key evil-visual-state-map "u" #'undo-fu-only-undo)
; (define-key evil-visual-state-map "U" #'undo-fu-only-redo)

  (use-package! avy)

;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package! elec-pair
  :ensure nil
  :init
  (electric-pair-mode 1))

(show-paren-mode 1)

;; Prevent parenthesis imbalance
(use-package! paredit
  :commands paredit-mode
  :hook
  (emacs-lisp-mode . paredit-mode)
  :config
  (define-key paredit-mode-map (kbd "RET") nil))

;; For paredit+Evil mode users: enhances paredit with Evil mode compatibility
;; --------------------------------------------------------------------------
(use-package! enhanced-evil-paredit
  :commands enhanced-evil-paredit-mode
  :hook
  (paredit-mode . enhanced-evil-paredit-mode))

;; Displays visible indicators for page breaks
(use-package! page-break-lines
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package! elisp-refs
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

(use-package! async
  :config
  (dired-async-mode 1)
  )

(use-package! eldoc-box
  :hook (prog-mode . eldoc-box-hover-at-point-mode)
  )

  ;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package! autorevert
  :ensure nil
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  (global-auto-revert-mode 1))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package! recentf
  :ensure nil
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))
  ;; Enable `recentf-mode'
  (recentf-mode 1)

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package! savehist
  :ensure nil
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600)
  (savehist-mode 1))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package! saveplace
  :ensure nil
  :init
  (setq save-place-limit 400)
  (save-place-mode 1))

(use-package! projectile
    :config
    (projectile-mode +1)
    ;; (keyb/leader-key
    ;;   "gf" 'projectile-find-file)
    ;; :general
    ;; ("SPC gf" 'projectile-find-file)
    )

  (use-package! dirvish
    :ensure nil
    :init
    :config

    (dirvish-override-dired-mode)
    (use-package! dired
        :config
        (setq dired-listing-switches
            "-l --almost-all --human-readable --group-directories-first --no-group")
        ;; this command is useful when you want to close the window of `dirvish-side'
        ;; automatically when opening a file
        (put 'dired-find-alternate-file 'disabled nil))
    (setq dirvish-default-target 'current)
   (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index))
        delete-by-moving-to-trash t
        )
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish)
   :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu))
    )

  (use-package! vertico

          :bind (:map vertico-map
        	      ("C-k" . vertico-next)
        	      ("C-j" . vertico-previous))
          :custom
          (vertico-cycle t)
          :init
          (vertico-mode)
          :hook after-init
          :config
          (vertico-reverse-mode) ; we want the command on bottom
      (setq context-menu-mode t
          ;; Support opening new minibuffers from inside existing minibuffers.
          enable-recursive-minibuffers t
          ;; Hide commands in M-x which do not work in the current mode.	Vertico
          ;; commands are hidden in normal buffers. This setting is useful beyond
          ;; Vertico.
          read-extended-command-predicate #'command-completion-default-include-p
          ;; Do not allow the cursor in the minibuffer prompt
          minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
	   )


(use-package! savehist
        :ensure nil
        :hook (after-init . savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package! marginalia

  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
	   ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package! such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

  (use-package! orderless

    :custom
    ;; Configure a custom style dispatcher (see the Consult wiki)
    ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
    ;; (orderless-component-separator #'orderless-escapable-split-on-space)
    (completion-styles '(orderless basic))
    (completion-category-overrides '((file (styles partial-completion))))
    (completion-category-defaults nil) ;; Disable defaults, use our settings
    (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Embark integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive environment for managing completions and interactions.
(use-package! embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package! embark-consult)

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.

(use-package! consult
  ;; Replace bindings. Lazily loaded by `use-package!'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ;; ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; :general
  ;; (:states 'normal
  ;;          "SPC nh" '(consult-org-heading :wk "goto header")
  ;;          )
  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

  (use-package! display-line-numbers
    :ensure nil
    :init
    (setq display-line-numbers-type 'relative)
    (global-display-line-numbers-mode)
    )

(use-package! doom-modeline
  :init (doom-modeline-mode 1)
  :demand t
  :config
  (setq doom-modeline-time-icon t
	doom-modeline-major-mode-color-icon t
	doom-modeline-buffer-state-icon t
	doom-modeline-lsp-icon t
	doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode)
	doom-modeline-time t
	doom-modeline-vcs-max-length 5
	)
  (display-time-mode 1)

  )

(setq doom-modeline-height 15)

;; (use-package! doom-modeline-now-playing
;;   :after doom-modeline
;;   :config
;;   (doom-modeline-now-playing-timer)
;;   (setq doom-modeline-now-playing-playerctl-ignored-players '("kdeconnect" "firefox")
;;         doom-modeline-now-playing-max-length 30
;; 	)
;;   )

;; (doom-modeline-def-modeline 'main
;;   '(bar workspace-name persp-name window-number modals matches buffer-info remote-host buffer-position parrot selection-info)
;;   '(objed-state misc-info battery grip irc mu4e gnus github debug repl lsp input-method vcs time))

  (use-package! indent-bars
    :hook ((
            prog-mode
  	  )
  	 . indent-bars-mode)
    )

(when (eq system-type 'windows-nt)
  (use-package! doom-themes
    ;; :ensure t
    :custom
    ;; Global settings (defaults)
    (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
    (doom-themes-enable-italic t) ; if nil, italics is universally disabled
    ;; for treemacs users
    (doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
    :config
    (load-theme 'doom-outrun-electric t)
    (custom-set-faces
                                        ; '(font-lock-comment-face ((t (:foreground ,(doom-color 'base6)))))
     )

    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Enable custom neotree theme (nerd-icons must be installed!)
    (doom-themes-neotree-config)
    ;; or for treemacs users
    ;; (doom-themes-treemacs-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))

  )

(when (eq system-type 'gnu/linux)
  (use-package! doom-themes

    :custom
    (doom-themes-enable-bold t)
    (doom-themes-enable-italic t)
    :config
    (doom-themes-org-config)
    (load-theme 'doom-dark+ t)
    )
  )

;; Set up the Language Server Protocol (LSP) servers using Eglot.
(use-package! eglot
  :ensure nil
  :hook lsp-mode
  :commands eglot-mode
  ;; :commands (eglot-ensure
             ;; eglot-rename
             ;; eglot-format-buffer)
  )

(use-package! lsp-mode

  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
         prog-mode
         )
  :commands lsp
  )

;; optionally
(use-package! lsp-ui  :commands lsp-ui-mode)

(use-package! dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 80 ensures it is used only when no
  ;; more specific backend is available.
  (with-eval-after-load 'xref
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 80))

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  :config
  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

;; Intelligent code folding by using the structural understanding of the
;; built-in tree-sitter parser. Unlike traditional folding methods that rely on
;; regular expressions or indentation, treesit-fold uses the actual syntax tree
;; of the code to accurately identify foldable regions such as functions,
;; classes, comments, and documentation strings. This allows for faster and more
;; precise folding behavior that respects the grammar of the programming
;; language, ensuring that fold boundaries are always syntactically correct even
;; in complex or nested code structures.
(use-package! treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)

  :init
  (setq treesit-fold-line-count-show t)
  (setq treesit-fold-line-count-format " ▼")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))

;; A few examples
(add-hook 'c-ts-mode-hook #'treesit-fold-mode)
(add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
(add-hook 'php-ts-mode-hook #'treesit-fold-mode)
(add-hook 'css-ts-mode-hook #'treesit-fold-mode)
(add-hook 'html-ts-mode-hook #'treesit-fold-mode)
(add-hook 'bash-ts-mode-hook #'treesit-fold-mode)

(when (eq system-type 'gnu/linux)
  (use-package! jjdescription
    :commands jjdescription-mode
    )
  )

(use-package! diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

  (use-package! aggressive-indent
    :hook (prog-mode)
    )

;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
(use-package! stripspace
  :commands stripspace-local-mode

  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :init
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (setq stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (setq stripspace-restore-column t))

(use-package! org
  :ensure nil
  :commands (org-mode org-version)
  :after general
  :mode
  ("\\.org\\'" . org-mode)

  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (awk . t)
     (calc .t)
     (C . t)
     (emacs-lisp . t)
     (haskell . t)
     (gnuplot . t)
     (latex . t)
     ;; (ledger . t)
     (js . t)
     (haskell . t)
     (perl . t)
     (python . t)
     (R . t)
     (scheme . t)
     (shell . t)
     (sql . t)
     ))
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'org-mode-hook 'display-line-numbers-mode)
  ;; (keyb/leader-key
  ;;   (:states 'normal
  ;;            "TAB" 'org-cycle
  ;;            "nm" 'olivetti-mode
  ;;            )
    ;; )


  ;; :general
  ;; (:states 'normal
  ;;          "TAB" 'org-cycle
  ;;          "SPC nm" '(olivetti-mode :wk "toggle olivetti")
  ;;          )

  :custom
  (org-export-with-broken-links t)
  (org-startup-with-inline-images t)
  (org-M-RET-may-split-line '((default . nil)))
  (org-log-into-drawer t)
  (org-indirect-buffer-display 'current-window)

  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t)
  )

(use-package! evil-org
  ;; :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package! org-sticky-header
  :hook org-mode
  :custom
  (org-sticky-header-full-path 'full))

      (use-package! org-superstar

	:hook org-mode)

 ; note - not recursive by default

(use-package! org-agenda
  :ensure nil
  :config


  ;; (setq org-agenda-files
  ;;       (expand-file-name "org-agenda-files.txt" org-directory))
  (setq org-agenda-files '("~/org/agenda"
                           "~/org/roam"
                           "~/org/roam/daily/"
                           "~/org/contacts"
                           ))

                                        ; reload with timer
                                        ; (run-with-idle-timer 300 t (lambda () (org-agenda nil "a")) )

  (setq org-agenda-span 1
        org-agenda-start-day "+0d"
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-deadline-is-done t
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-remove-tags nil
        org-agenda-window-setup "other-tab"
        org-habit-following-days 0
                                        ; how manyh days before
        org-habit-preceding-days 10
                                        ; ho far the graph should be shown
        org-habit-graph-column 80
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-agenda-prefix-format '((dashboard-agenda . " %-12:c %s ")
                                   (agenda . " %i %?-12t% s") (todo . " %-12:c")
                                   (tags . " %-12:c") (search . " %-12:c"))
        )
  (setq org-todo-keywords '((sequence "TODO"
                                      "PROG"
                                      "|"
                                      "DONE"
                                      "DELEGATED"
                                      "SKIPPED"
                                      )))

  (advice-add 'org-agenda-todo :after 'org-save-all-org-buffers)
  (advice-add 'org-agenda-clock-in :after 'org-save-all-org-buffers)
  (advice-add 'org-agenda-clock-out :after 'org-save-all-org-buffers)

  (setq org-agenda-custom-commands
        '(("c" . "My Custom Agendas")
          ("cu" "Unscheduled TODO"
           ((todo ""
                  ((org-agenda-overriding-header "\nUnscheduled TODO")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
           nil
           nil)))

  )

  (use-package! org-habit-stats
    )

  (use-package! org-timeblock
    :ensure (:host github :repo "ichernyshovvv/org-timeblock")
    )

(use-package! org-roam
  :init
  :after org general
  :config
  (org-roam-setup)
  (org-roam-db-autosync-mode)
  ;; (keyb/leader-key
  ;;   (:states 'normal
  ;;            "nf" 'org-roam-node-find
  ;;            "nd" 'org-roam-dailies-goto-today
  ;;            "nD" 'org-roam-dailies-goto-date
  ;;            "nb" 'org-roam-buffer-toggle
  ;;            "ni" 'org-roam-node-insert
  ;;            "ncf" 'org-roam-capture
  ;;            "ncc" 'org-roam-dailies-capture-today
  ;;            "ncd" 'org-roam-dailies-capture-date
  ;;            )
  ;;   )
  ;; :general
  ;; (:states 'normal
  ;;          "SPC nf" 'org-roam-node-find
  ;;          "SPC nd" 'org-roam-dailies-goto-today
  ;;          "SPC nD" 'org-roam-dailies-goto-date
  ;;          "SPC nb" 'org-roam-buffer-toggle
  ;;          "SPC ni" 'org-roam-node-insert
  ;;          "SPC ncf" 'org-roam-capture
  ;;          "SPC ncc" 'org-roam-dailies-capture-today
  ;;          "SPC ncd" 'org-roam-dailies-capture-date
  ;;          )
  :custom
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template "${title} ${tags}")
  (org-roam-file-extensions '("org" "md"))
  (org-roam-directory (file-truename "~/org/roam/"))
  )

(use-package! org-mem
  :config
  (setq org-mem-watch-dirs
        (list "~/org/roam")) ;; Your org-roam-directory here
  (org-mem-updater-mode))

(use-package! org-node
  :after general
  ;; :general
  ;; (:states 'normal
  ;;          "SPC nN" '(org-node-nodeify-entry :wk "generate node at header")
  ;;          )

  :config
  (use-package! org-transclusion
    ;; :ensure nil
    ;; :general
    ;; (:states 'normal
    ;;          "SPC nI" '(org-node-insert-transclusion-as-subtree :wk "insert transclusion")
    ;;          )
    )
  (org-node-cache-mode)
  (org-node-roam-accelerator-mode)
  (setq org-node-creation-fn #'org-node-new-via-roam-capture)
  (setq org-node-file-slug-fn #'org-node-slugify-like-roam-default)
  (setq org-node-file-timestamp-format "%Y%m%d%H%M%S-")
  (setq auto-save-visited-interval 2)
  (auto-save-visited-mode)
  (org-node-complete-at-point-mode t)
  (setq org-roam-completion-everwhere nil)

  (setq org-node-property-mtime "mtime")
  (add-hook 'org-node-modification-hook
            #'org-node-update-mtime-property)
  (setq org-node-display-sort-fn #'org-node-sort-by-mtime-property)
  )

(use-package! folgezett
  :straight (:host github :repo "landerwells/folgezett.el")
  :after org-roam
  :hook org-roam
  :config
  (folgezett-setup)
  (folgezett-mode)
  :custom
  (folgezett-db-link-parent t)
  (folgezett-include-id-in-filename t)
  (folgezett-db-link-parent t)
  (folgezett-capture-keys '("m"))
  )

(use-package! org-roam-latte
  :hook ((text-mode . org-roam-latte-mode)
	 (prog-mode . org-roam-latte-mode))
  ;; :general
  ;; (:states 'normal
  ;;          "SPC nl" '(org-roam-latte-complete-at-point :wk "convert to link")
  ;;          )
  )

(use-package! md-roam
  :init
  (setq org-roam-file-extension '("org" "md"))
  (md-roam-mode 1)
  (setq md-roam-file-extension '("md"))
  :ensure (:host github :repo "nobiot/md-roam")
  :config
  )

(use-package! org-download

  :after org
  ;; :defer nil
  ;; :general
  ;; (:states 'normal
  ;;          "SPC np" '(org-download-clipboard :wk "paste asset")
   ;;         )
  :custom
  (org-download-link-format "[[file:%s]]\n")
  (org-download-abbreviate-filename-function #'file-relative-name)
  (org-download-image-dir ".assets")
  (org-download-heading-lvl nil)
  (org-download-actual-width 600)
  )

(use-package! org-transclusion
  :hook org
  ;; :general
  ;; (:states 'normal
  ;;          "SPC ntt" '(org-transclusion-add :wk "add transclusion")
  ;;          "SPC ntm" '(org-transclusion-transient-menu :wk "transclusion menu")
  ;;          )
  )

(use-package! org-cliplink
  )

(use-package! org-autolist
  :hook org-mode)

(use-package! olivetti
  :hook org-mode markdown-mode
  ;; :general
  ;; (:states 'normal
   ;;         "SPC nm" '(olivetti-mode :wk "toggle olivetti")
   ;;         )
  :custom
  (olivetti-body-width 0.7)
  (olivetti-style 'fancy)
  )

(use-package! org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))

(setq org-appear-autoemphasis t
      org-appear-autolinks t
      org-appear-autosubmarkers t
      org-appear-autoentities t
      org-appear-autokeywords t
      )

(when (eq system-type 'gnu/linux)
  (use-package! ledger-mode
    :hook (ledger-reconcile-mode . ledger-reconcile-display-balance-in-header-mode)
    :custom
    (ledger-reconcile-buffer-payee-max-chars '20)
    (ledger-reconcile-buffer-account-max-chars '20)
    (ledger-reconcile-force-window-bottom t)
    (ledger-reconcile-insert-effective-date t)
    (ledger-reports
     '(("bal"            "%(binary) -f %(ledger-file) bal")
       ("bal this month" "%(binary) -f %(ledger-file) bal -p %(month) -S amount")
       ("bal this year"  "%(binary) -f %(ledger-file) bal -p 'this year'")
       ("net worth"      "%(binary) -f %(ledger-file) bal Assets Liabilities")
       ("account"        "%(binary) -f %(ledger-file) reg %(account)")))
    :config
    )
  )

(when (eq system-type 'gnu/linux)
  (use-package! evil-ledger
    :hook ledger-mode
    :after ledger-mode
    :custom
    (evil-ledger-sort-key "S")
    ;; (add-hook 'ledger-mode-hook #'evil-ledger-mode)
    )
  )

(when (eq system-type 'gnu/linux)
  (use-package! sops
    :ensure (:type git :host github :repo "djgoku/sops")
    :init
    (global-sops-mode 1))
  )

(use-package! yaml-mode
  :mode "\\.yml\\'")
