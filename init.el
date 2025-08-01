;;; package: --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; MY PATH
(add-to-list 'load-path "~/.emacs.d/settings")
;; Package
(require 'package-settings)

(require 'font-settings)

(require 'unicode-settings)

(require 'rock-defuns)
(keymap-global-set "C-c e" 'tws-region-to-process)

(require 'dashboard-settings)
(require 'meow-settings)

(require 'custom-functions)
(require 'auth-settings)
(require 'general-settings)
(require 'asdf-settings)

;; HELM <3
;; (require 'helm-settings)
(require 'vertico-settings)

;;---------;
;;  THEME  ;
;;---------;
(require 'theme-settings)
(set-full-paren)
;; (set-sanityinc)
;; (set-catppuccin)
;; (set-ef-theme) ;; EF themes, cute
;; (set-nord-theme) ;; Nord theme, low contrast
;; (set-yin-theme) ;; Black & white theme
;; (set-random-theme)

;;------------;
;; Some modes ;
;;------------;
(require 'term-settings)
;; (set-emux)
;; (emux-default-sessions)

(require 'org-settings)
;; (enable-beamer)

;; https://github.com/eschulte/epresent
;; (load-file (expand-file-name "~/.emacs.d/plugins/epresent/epresent.el"))
;; (require 'presentation-settings)

(require 'calendar-settings)

(require 'random-requires) ;; Functions for some modes and other things

(require 'casual-settings)

(require 'projectile-settings)

(require 'auto-complete-settings)
(require 'yasnippet-settings)
(require 'acejump-settings)

;; (require 'lsp-bridge-settings)

;; (require 'tags-settings)

;; (require 'cheatsheet-settings)

;;----------------;
;;      MAGIT     ;
;;----------------;
(require 'magit-settings)
(require 'copilot-settings)

;;----------------;
;;    SPOTIFY     ;
;;----------------;
;; (require 'spotify-settings)

;;----------------;
;;    LANGUAGES   ;
;;----------------;
(require 'company-settings)
(require 'flycheck-settings)
(require 'programming-settings)

;; (require 'aider-settings)

;; MINE SHIT
(defun tegmacs-load ()
    (add-to-list 'load-path "~/Git/tegmacs")
    (load-file "~/Git/tegmacs/tegmacs.el")
    (require 'tegmacs)
    (setq tegmacs-message-mark-as-read nil))

;; (tegmacs-load)

(put 'downcase-region 'disabled nil)

(set-ef-theme) ;; EF themes, cute
(set-nord-theme) ;; Nord theme, low contrast

;;; init.el ends here
