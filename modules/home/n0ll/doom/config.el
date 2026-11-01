;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(set-face-attribute 'default nil :height 90)

(setq auto-save-default t
      make-backup-files t
      )

(setq doom-theme 'doom-moonlight)

(setq display-line-numbers-type 'relative)

(use-package! doom-modeline
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

;;;;;;;;;;;;;;;
;; ;;;;;;;;; ;;
;; ;; Org ;; ;;
;; ;;;;;;;;; ;;
;;;;;;;;;;;;;;;

(use-package org-transclusion
  :after org
  )

(use-package! org-autolist
  :hook org-mode)

(use-package! org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t)
  (org-appear-autokeywords t)
  )

;;;;;;;;;;;;;;;;
;; Org Agenda ;;
;;;;;;;;;;;;;;;;
(setq org-agenda-files '("~/org/agenda"
                         "~/org/roam"
                         "~/org/roam/daily/"
                         "~/org/contacts"
                         ))



(with-eval-after-load 'org-agenda
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-with-log-mode t
        org-agenda-time-grid '((daily) (600 1200 1800) "---" "-----")
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-span 1
        org-agenda-start-day "+0d"
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-deadline-is-done t
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-remove-tags nil
        )
  (setq org-agenda-custom-commands
        '(("c" . "My Custom Agendas")
          ("cu" "Unscheduled TODO"
           ((todo ""
                  ((org-agenda-overriding-header "\nUnscheduled TODO")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
           nil
           nil)))
  )

(use-package! org-super-agenda
  ;; is a global package, just best to turn it on after loading
  :init
  (setq! org-super-agenda-header-map nil) ; stop using super agenda binds, conflicts with evil
  :hook after-init
  :custom
  (org-super-agenda-groups
   '(
     (:name "schedule"
      :time-grid t
      :and (
            :todo nil
            :date today
            )
      )
     (:auto-category t
      :children t
      :and (
            :habit t
            :todo t
            :date today
            )
      )
     (:name "tomorrow"
      :time-grid t
      :and (
            :todo nil
            :date tomorrow
            )
      )
     )

   )
  )

(use-package! calfw-blocks
  :after calfw
  )

;;;;;;;;;;;;;;
;; Org Roam ;;
;;;;;;;;;;;;;;
(use-package! org-roam-timestamps
  :after org-roam
  :config
  (org-roam-timestamps-mode)
  :custom
  (org-roam-timestamps-parent-file nil)
  )

;; TODO binds
(use-package! org-roam-latte
  :hook (
         (text-mode . org-roam-latte-mode)
	 (prog-mode . org-roam-latte-mode)
         )
  )

;; (use-package! md-roam
;;   :config
;;   (setq org-roam-file-extension '("org" "md"))
;;   (md-roam-mode 1)
;;   (setq md-roam-file-extension '("md"))
;;   )

;;;;;;;;;;;;;

;; parse org file for config
;; not as useful when using doom, undecided on it currently
;; (org-babel-load-file "~/.config/doom/user.org")
