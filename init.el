                                        ; @begin(76331830)@ - Do not edit these lines - added automatically!
(if (file-exists-p "/home/rock/Descargas/temp/CiaoDE-1.15-1781-g328b907/emacs-mode/ciao-site-file.el")
    (load-file "/home/rock/Descargas/temp/CiaoDE-1.15-1781-g328b907/emacs-mode/ciao-site-file.el")
  )
                                        ; @end(76331830)@ - End of automatically added lines.

;; .emacs
(setq user-full-name "Rock Neurotiko"
      user-mail-address (concat "miguelglafuente" "@" "gmail" ".com"))

;; cool frame title with currently edited buffer name
(setq frame-title-format
      (concat "%b - " invocation-name "@" system-name))

(menu-bar-mode -1)
(tool-bar-mode -1)

;; MY PATH
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/settings")

;; Custom Vars :)
(require 'custom-variables)

;; IRC
(require 'irc-settings)

;; Package
(require 'package-settings)

(require 'theme-settings)
(set-linum)
(set-full-paren)
(set-powerline)
(set-moe)
;; (set-random-theme)

(require 'rock-defuns)
(require 'general-settings)

(require 'random-requires) ;; Functions for some modes and other things

;; ido and flx
(require 'ido-settings)

;; HELM <3
(require 'helm-settings)

;; js completion
(require 'js-settings)
;; (load-tern)
;; (load-angular)

;; from: random-requires
(set-undo)
(set-outline)
(set-autoindent)
(set-git-gutter-fringe+)



(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)



(require 'smooth-scroll)
(require 'smooth-scrolling)


;; UML
(set-uml-plantuml)
(set-libreoffice)
(set-realtime-markdown)

(load-web-mode)

(set-auto-complete)

;;----------------;
;;    LANGUAGES   ;
;;----------------;

;; JULIA
(require 'julia-settings)
;; GO
(require 'go-settings)
;; SCALA
(require 'scala-settings)
;; Python
(require 'python-settings)
(set-ipython)
(set-pycomplete)
(set-flymake)
(set-virtualenv)



;; My funcs

(set-indent-guide)
(set-pair)
(set-multiple-cursors)
;; (set-zone)

(set-helm-swoop)

;; Auto package update
;; (require 'auto-package-update)
;; (auto-package-update-maybe)


;; OCAML
(add-to-list 'load-path "/home/rock/.opam/4.01.0/share/emacs/site-lisp")
(add-to-list 'load-path "/home/rock/.opam/4.01.0/bin/")
(require 'merlin)
(require 'ocp-indent)

;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(setq merlin-use-auto-complete-mode t)
(setq merlin-error-after-save nil)

;; (load "~/.emacs.d/plugins/mochi.el")

;; (setq-default indent-tabs-mode nil)
