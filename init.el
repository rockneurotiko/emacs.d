(package-initialize nil)

;; MY PATH
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/settings")

(require 'rock-defuns)
(require 'general-settings)

;; IRC
;; (require 'irc-settings)

;; Package
(require 'package-settings)


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
(set-powerline)
(set-moe)
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
;; (set-org-babel)
(require 'presentation-settings)


(require 'tags-settings)

(require 'random-requires) ;; Functions for some modes and other things
(set-undo) ;; Ctrl-z powered
;; (set-outline) ;; outline mode
(set-autoindent) ;; Thanks for indent!
(set-git-gutter-fringe+) ;; Simbols in left :)
(set-auto-complete) ;; Auto complete with local definitions
(set-scroll) ;; Smooth scroll ^^
(set-indent-guide)  ;; The indent vertical lines.. cute!
(set-pair)  ;; How to pair? autopair or smartparens?
(set-multiple-cursors)  ;; The more, the better
(set-uniquify)  ;; Buffer names uniques! (set-auto-package) ;; Auto update all
;; packages (set-zone) ;; Zone the code (set-uml-plantuml) ;; UML from text
;; (set-uml-plantuml)  ;; UML from text biatch!

;; biatch! (set-libreoffice) ;; You don't need libreoffice biatch
;; (set-livedown)

;; it.. not good XD
;; (set-evil-ranger) ;; Range mode
;; (set-auto-package)  ;; Auto update all packages
;; (set-libreoffice) ;; You don't need libreoffice biatch
;; (set-mochi)  ;; I tried to do it.. not good XD

;; (require 'projectile-settings)

(require 'yasnippet-settings)
(require 'acejump-settings)
(require 'font-settings)

;; (require 'camelcase-settings)
(require 'cheatsheet-settings)
;;----------------;
;;      MAGIT     ;
;;----------------;
(require 'magit-settings)

;;----------------;
;;    LANGUAGES   ;
;;----------------;
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
    (require 'tegmacs))
(tegmacs-load)

(require 'ox-taskjuggler)

;; (require 'exwm-settings)
