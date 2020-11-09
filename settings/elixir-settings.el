(use-package alchemist
  :ensure t
  :config
  (add-hook 'elixir-mode-hook (lambda () (setq auto-indent-on-visit-file nil)))
  (setq alchemist-mix-command "~/.asdf/shims/mix")
  (setq alchemist-iex-program-name "~/.asdf/shims/iex")
  (setq alchemist-execute-command "~/.asdf/shims/elixir")
  (setq alchemist-compile-command "~/.asdf/shims/elixirc")
  (setq alchemist-mix-env 'test)
  )



;; (use-package lsp-mode
;;   :ensure t
;;   :commands lsp
;;   :init
;;   (setq lsp-clients-elixir-server-executable "elixirls")
;;   (setq lsp-eldoc-enable-hover nil)
;;   (setq lsp-enable-completion-at-point t)
;;   )

;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode
;;   :config
;;   (setq lsp-ui-flycheck-enable t)
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp
;;   :config
;;   (push 'company-lsp company-backends))

;; (use-package elixir-mode
;;   :ensure t
;;   :config
;;   (add-hook 'elixir-mode-hook 'flycheck-mode)
;;   (add-hook
;;    'elixir-mode-hook
;;    (lambda ()
;;      (lsp)
;;      (flycheck-mode)
;;      ;; (add-hook 'before-save-hook 'lsp-format-buffer nil t)

;;      ))
;;   )

(use-package elixir-yasnippets
  :ensure t)

(defun ex-fmt-load ()
  (add-to-list 'load-path "~/Git/ex-fmt")
  (load-file "~/Git/ex-fmt/ex-fmt.el")
  (require 'ex-fmt)
  ;; (setq ex-fmt-elixir "/Users/rock/.asdf/shims/elixir")
  ;; (setq ex-fmt-mix "/Users/rock/.asdf/shims/mix")
  ;; (setq ex-fmt-elixir "/Users/rock/.asdf/installs/elixir/1.6.5-otp-20/bin/elixir")
  ;; (setq ex-fmt-mix "/Users/rock/.asdf/installs/elixir/1.6.5-otp-20/bin/mix")

  ;; (setq ex-fmt-elixir "/Users/rock/.asdf/installs/elixir/1.7/bin/elixir")
  ;; (setq ex-fmt-mix "/Users/rock/.asdf/installs/elixir/1.7/bin/mix")

  (setq ex-fmt-elixir "elixir")
  (setq ex-fmt-mix "mix")
  (add-hook 'after-save-hook #'ex-fmt-after-save))
(ex-fmt-load)
(provide 'elixir-settings)
