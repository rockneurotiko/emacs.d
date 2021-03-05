;; (use-package alchemist
;;   :ensure t)

(use-package elixir-mode
  :ensure t)

(setq lsp-keymap-prefix "M-s")

(use-package lsp-mode
  :ensure t
  :hook (
   (elixir-mode . lsp)
   (before-save . lsp-format-buffer)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  (add-to-list 'exec-path "~/.emacs.d/settings/elixir-ls/elixir-1.11")
  (setq lsp-enable-file-watchers nil))

;; (use-package lsp-ui :commands lsp-ui-mode)
(use-package helm-lsp
  :ensure t
  :diminish lsp-mode
  :commands helm-lsp-workspace-symbol)

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
