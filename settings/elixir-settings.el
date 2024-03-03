(use-package elixir-mode
  :ensure t)

(setq lsp-bridge-elixir-lsp-server "lexical")

(setq lsp-keymap-prefix "M-s")
(setq lsp-elixir-ls-version "v0.20.0")

(use-package lsp-mode
  :ensure t
  :hook (
   (elixir-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  ;; (add-to-list 'exec-path "~/.emacs.d/settings/elixir-ls/elixir-1.15")

  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

  (setq lsp-enable-file-watchers nil)

  ;; :custom
  ;; (lsp-elixir-server-command '("/Users/mgarcial/Git/lexical/_build/dev/package/lexical/bin/start_lexical.sh"))
  )

(setenv "PATH" (concat (expand-file-name "~/Git/lexical/_build/dev/package/lexical/bin") ":" (getenv "PATH")))

;; (use-package lsp-ui :commands lsp-ui-mode)

(use-package helm-lsp
  :ensure t
  :diminish lsp-mode
  :commands helm-lsp-workspace-symbol)

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
