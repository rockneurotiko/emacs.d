;; -*- lexical-binding: t; -*-
(use-package eglot
  :ensure t
  :straight (:type built-in)

  :init
  (add-hook 'elixir-ts-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format t t)))

  (add-hook 'heex-ts-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format t t)))

  :config



  (add-to-list 'eglot-server-programs '(elixir-ts-mode "/home/rock/.emacs.d/.cache/elixir-ls/language_server.sh"))
  (add-to-list 'eglot-server-programs '(heex-ts-mode "/home/rock/.emacse.d/.cache/elixir-ls/language_server.sh"))

  ;; Or in .dir-locals.el like ((nil (eglot-workspace-configuration . ((elixirLS . ((configurationSources . ["flake8"])))))))
  (setq-default eglot-workspace-configuration
                '((:elixirLS . (:autoBuild t
                                :dialyzerEnabled t
                                :incrementalDialyzer t
                                :dialyzerWarnOpts []
                                :dialyzerFormat "dialyxir_long"
                                :mixEnv "dev"
                                :projectDir nil
                                :fetchDeps t
                                :suggestSpecs nil
                                :autoInsertRequiredAlias t
                                :signatureAfterComplete t
                                :enableTestLenses t
                                ))))

  :hook
  (elixir-mode . eglot-ensure)
  (elixir-ts-mode . eglot-ensure)
  (heex-ts-mode . eglot-ensure)

  :custom
  (eglot-events-buffer-config '(:size 1000 :format full))

  ;; TODO bind eglot-mode-map
  )

(use-package eglot-booster
  :straight (eglot-booster :type git :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode)
  :custom
  (eglot-booster-io-only t))

(provide 'eglot-settings)
