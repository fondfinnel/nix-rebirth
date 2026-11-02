;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;; declare custom packages to be installed here
;; if it's not in nixpkgs, it needs to be pinned to a revision

(package! sops)
(package! figlet)

;;;;;;;;;;;;;;;
;; ;;;;;;;;; ;;
;; ;; Org ;; ;;
;; ;;;;;;;;; ;;
;;;;;;;;;;;;;;;
(package! org-transclusion)
(package! org-autolist)
(package! org-appear)

;;;;;;;;;;;;;;;;
;; Org Agenda ;;
;;;;;;;;;;;;;;;;
(package! org-super-agenda)
;; (package! calfw-blocks
;;   :recipe (:host github :repo "ml729/calfw-blocks")
;;   :pin "0fe829035ffa491c3f2610f05a7f1ec936a4497e")
(package! org-wild-notifier)

;;;;;;;;;;;;;;
;; Org Roam ;;
;;;;;;;;;;;;;;
(package! org-roam-timestamps) ;; timestamps on files
(package! org-roam-latte) ;; highlights links available in org notes
(package! org-roam-ui) ;; webgui graph for notes
;; (package! md-roam  ;; markdown files for roam
;;   :recipe (:host github :repo "nobiot/md-roam")
;;   )

;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;; ;;
;; ;; Programming ;; ;;
;; ;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
;; Jujutsu ;;
;;;;;;;;;;;;;
(package! majutsu :recipe (:host github :repo "0WD0/majutsu"))
(package! jjdescription)
