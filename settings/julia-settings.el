;;JULIA
(use-package ess
  :ensure t
  :init (setq inferior-julia-program-name "julia"))

(load "~/.emacs.d/plugins/ESS/lisp/ess-site.el")

(provide 'julia-settings)
