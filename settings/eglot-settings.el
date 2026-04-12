;; -*- lexical-binding: nil; -*-

(use-package eglot
  :ensure nil
  :init
  (advice-add 'eglot-find-implementation :before 'add-point-to-find-tag-marker-ring)
  (advice-add 'eglot-find-typeDefinition :before 'add-point-to-find-tag-marker-ring)

  :config

  (setf
   (alist-get '(elixir-mode elixir-ts-mode heex-ts-mode)
                   eglot-server-programs
                   nil nil #'equal)
   (eglot-alternatives
    '(("/home/rock/.local/share/mise/shims/dexter" "lsp"))
    ;; '(("/home/rock/.local/bin/expert" "--stdio"))
    ;; '("/home/rock/.emacs.d/.cache/elixir-ls/language_server.sh")
    )
   )

  (setq-default eglot-workspace-configuration
  '(:expert (:workspaceSymbols (:minQueryLength 0))))


  :hook
  (eglot-managed-mode . (lambda ()
                          (rock/completions-reset-set
                           #'eglot-completion-at-point
                           #'cape-dabbrev
                           #'cape-keyword
                           #'cape-file
                           t)))

  (elixir-mode . eglot-ensure)
  (elixir-ts-mode . eglot-ensure)
  (heex-mode . eglot-ensure)
  (heex-ts-mode . eglot-ensure)

  (elixir-mode . (lambda () (add-hook 'before-save-hook #'eglot-format t t)))
  (elixir-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format t t)))
  (heex-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format t t)))

  :setopt
  (eglot-events-buffer-config '(:size 1000 :format full))

  ;; todo bind eglot-mode-map
  )

(use-package eglot-booster
  :ensure (eglot-booster :host github :repo "jdtsmith/eglot-booster")
  :config
  (eglot-booster-mode)
  :setopt
  (eglot-booster-io-only t))

(use-package consult-eglot
  :ensure t
  :after eglot
  :bind ("M-s i" . consult-eglot-symbols))

(provide 'eglot-settings)
