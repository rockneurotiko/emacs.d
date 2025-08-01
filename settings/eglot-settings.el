;; -*- lexical-binding: nil; -*-

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
  (add-to-list 'eglot-server-programs '(markdown-mode . ("harper-ls" "--stdio")))
  (add-to-list 'eglot-server-programs '((markdown-ts-mode :language-id "markdown") . ("harper-ls" "--stdio")))
  (add-to-list 'eglot-server-programs '((org-mode :language-id "org") . ("harper-ls" "--stdio")))



  ;; or in .dir-locals.el like ((nil (eglot-workspace-configuration . ((elixirls . ((configurationsources . ["flake8"])))))))
  (setq-default eglot-workspace-configuration
                '((:elixirls . (:autobuild t
                                           :dialyzerenabled t
                                           :incrementaldialyzer t
                                           :dialyzerwarnopts []
                                           :dialyzerformat "dialyxir_long"
                                           :mixenv "dev"
                                           :projectdir nil
                                           :fetchdeps t
                                           :suggestspecs nil
                                           :autoinsertrequiredalias t
                                           :signatureaftercomplete t
                                           :enabletestlenses t
                                           ))
                  (:harper-ls . (:userDictPath ""
                                               :fileDictPath ""
                                               :linters (:SpellCheck t
                                                     :SpelledNumbers :json-false
                                                     :AnA t
                                                     :SentenceCapitalization t
                                                     :UnclosedQuotes t
                                                     :WrongQuotes :json-false
                                                     :LongSentences :json-false
                                                     :RepeatedWords t
                                                     :Spaces t
                                                     :Matcher t
                                                     :CorrectNumberSuffix t)
                               :codeActions (:ForceStable :json-false)
                               :markdown (:IgnoreLinkTitle :json-false)
                               :diagnosticSeverity "hint"
                               :isolateEnglish :json-false
                               :dialect "American"
                               :maxFileLength 120000))
                  ))

  :hook
  (elixir-mode . eglot-ensure)
  (elixir-ts-mode . eglot-ensure)
  (heex-ts-mode . eglot-ensure)
  (markdown-mode . eglot-ensure)
  (markdown-ts-mode . eglot-ensure)
  (org-mode . eglot-ensure)

  :setopt
  (eglot-events-buffer-config '(:size 1000 :format full))

  ;; todo bind eglot-mode-map
  )

(use-package eglot-booster
  :ensure t
  :straight (eglot-booster :type git :host github :repo "jdtsmith/eglot-booster")
  :config
  (message "cfg booster")
  (eglot-booster-mode)
  :setopt
  (eglot-booster-io-only t))

(provide 'eglot-settings)
