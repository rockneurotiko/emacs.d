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
(require 'ox-taskjuggler)

;; https://github.com/eschulte/epresent
;; (load-file (expand-file-name "~/.emacs.d/plugins/epresent/epresent.el"))
(require 'presentation-settings)

(require 'calendar-settings)

(require 'rol-settings)

(require 'random-requires) ;; Functions for some modes and other things
(set-undo) ;; Ctrl-z powered
(set-autoindent) ;; Thanks for indent!
(set-git-gutter-fringe+) ;; Simbols in left :)
(set-auto-complete) ;; Auto complete with local definitions
(set-scroll) ;; Smooth scroll ^^
(set-indent-guide)  ;; The indent vertical lines.. cute!
(set-pair)  ;; How to pair? autopair or smartparens?
(set-multiple-cursors)  ;; The more, the better
(set-uniquify)  ;; Buffer names uniques! (set-auto-package) ;; Auto update all

;; (set-outline) ;; outline mode
;; packages (set-zone) ;; Zone the code (set-uml-plantuml) ;; UML from text
;; (set-uml-plantuml)  ;; UML from text biatch!

;; biatch! (set-libreoffice) ;; You don't need libreoffice biatch
;; (set-livedown)

;; it.. not good XD
;; (set-evil-ranger) ;; Range mode
;; (set-auto-package)  ;; Auto update all packages
;; (set-libreoffice) ;; You don't need libreoffice biatch
;; (set-mochi)  ;; I tried to do it.. not good XD

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

;; MINE SHIT
(defun tegmacs-load ()
    (add-to-list 'load-path "~/Git/tegmacs")
    (load-file "/home/rock/Git/tegmacs/tegmacs.el")
    (require 'tegmacs)
    (setq tegmacs-message-mark-as-read nil))

(tegmacs-load)

;; (require 'exwm-settings)
;;; init.el ends here
