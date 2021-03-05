;;; package: --- Summary
;;; Commentary:
;;; Code:

(package-initialize nil)

;; MY PATH
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/settings")
(require 'font-settings)
;; Package
(require 'package-settings)


(require 'rock-defuns)
(require 'general-settings)

;; IRC
;; (require 'irc-settings)


;; ido and flx
;; (require 'ido-settings)
;; HELM <3
(require 'helm-settings)
(set-helm-swoop)  ;;M-i and search all buffers!
;; (set-helm-ace-jump)

;;---------;
;;  THEME  ;
;;---------;
(require 'theme-settings)
(set-linum)
(set-full-paren)
(set-sanityinc)
;; (set-moe)

;; (set-random-theme)

;;------------;
;; Some modes ;
;;------------;
(require 'term-settings)
(set-multi-term)
;; (set-emux)
;; (emux-default-sessions)

(require 'org-settings)
(set-org-reveal)
(helm-org)
(set-ditaa)
(enable-beamer)
(set-org-babel)

;; (require 'ox-taskjuggler)

;; https://github.com/eschulte/epresent
;; (load-file (expand-file-name "~/.emacs.d/plugins/epresent/epresent.el"))
(require 'presentation-settings)

(require 'calendar-settings)

(require 'rol-settings)

(require 'random-requires) ;; Functions for some modes and other things
;; Undo C-z
;; Autoindent
;; Autocomplete
;; Smooth scroll
;; indent-guide
;; multi cursor
;; plantuml
(set-pair)  ;; Brackets pair
(set-uniquify)  ;; Buffer names uniques! (set-auto-package) ;; Auto update all
(load-comby-mode)

;; (set-outline) ;; outline mode
;; (set-livedown)

(require 'projectile-settings)


(require 'yasnippet-settings)
(require 'acejump-settings)
(require 'font-settings)

(require 'tags-settings)

(require 'cheatsheet-settings)

;;----------------;
;;      MAGIT     ;
;;----------------;
(require 'magit-settings)

;;----------------;
;;    SPOTIFY     ;
;;----------------;
(require 'spotify-settings)

;;----------------;
;;      MAIL      ;
;;----------------;
(require 'gnus-settings)

;;----------------;
;;    LANGUAGES   ;
;;----------------;
(require 'company-settings)
(require 'flycheck-settings)
(require 'programming-settings)

;;-------------------;
;;    WEBSEMANTICA   ;
;;-------------------;
;; (require 'websemantica-settings)
;; (set-turtle)

;; EPIC EMOJI
(package-require 'emojify)
(global-emojify-mode)

(require 'asdf-settings)

;; MINE SHIT
(defun tegmacs-load ()
    (add-to-list 'load-path "~/Git/tegmacs")
    (load-file "/home/rock/Git/tegmacs/tegmacs.el")
    (require 'tegmacs)
    (setq tegmacs-message-mark-as-read nil))

;; (tegmacs-load)

;; (require 'exwm-settings)
;;; init.el ends here
