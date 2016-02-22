;; MY PATH
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/settings")

(require 'rock-defuns)
(require 'general-settings)

;; IRC
(require 'irc-settings)

;; Package
(require 'package-settings)


;; ido and flx
(require 'ido-settings)
;; HELM <3
(require 'helm-settings)
(set-helm-swoop)  ;;M-i and search all buffers!


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
(require 'random-requires) ;; Functions for some modes and other things
(set-undo) ;; Ctrl-z powered
(set-outline) ;; outline mode
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
(set-livedown)
;; it.. not good XD
;; (set-evil-ranger) ;; Range mode
;; (set-auto-package)  ;; Auto update all packages
;; (set-libreoffice) ;; You don't need libreoffice biatch
;; (set-mochi)  ;; I tried to do it.. not good XD

;;----------------;
;;    LANGUAGES   ;
;;----------------;
(require 'programming-settings)

;;-------------------;
;;    WEBSEMANTICA   ;
;;-------------------;
(require 'websemantica-settings)
(set-turtle)
