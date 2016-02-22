;; If use bundled typescript.el,
;; (load "~/.emacs.d/plugins/emacs-tss/typescript.el")
;; (load "~/.emacs.d/plugins/emacs-tss/tss.el")

;; (add-to-list 'load-path "~/.emacs.d/plugins/emacs-tss")
(require 'typescript)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(require 'tss)


;; Key binding
(setq tss-popup-help-key "C-:")
(setq tss-jump-to-definition-key "C->")
(setq tss-implement-definition-key "C-c i")

;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "tss")

;; Do setting recommemded configuration
(tss-config-default)


;; (setq tss-module "commonjs")

(provide 'tss-settings)
