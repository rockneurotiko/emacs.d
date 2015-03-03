;; OCAML
(add-to-list 'load-path "/home/rock/.opam/4.01.0/share/emacs/site-lisp")
(add-to-list 'load-path "/home/rock/.opam/4.01.0/bin/")
(require 'merlin)
(require 'ocp-indent)

(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(setq merlin-use-auto-complete-mode t)
(setq merlin-error-after-save nil)

(provide 'ocaml-settings)
