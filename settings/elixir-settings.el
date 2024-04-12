(use-package elixir-mode
  :ensure t)

(use-package exunit
  :ensure t
  :hook (elixir-mode . exunit-mode))

(use-package elixir-yasnippets
  :ensure t)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; (defun ex-fmt-load ()
;;   (add-to-list 'load-path "~/Git/ex-fmt")
;;   (load-file (expand-file-name "~/Git/ex-fmt/ex-fmt.el"))
;;   (require 'ex-fmt)

;;   ;; Optional, if you want to use always an specific mix version
;;   (setq ex-fmt-mix nil)
;;   (setq ex-fmt-mix (expand-file-name "~/.asdf/shims/mix"))

;;   (add-hook 'after-save-hook #'ex-fmt-after-save))

;; (ex-fmt-load)

(provide 'elixir-settings)
