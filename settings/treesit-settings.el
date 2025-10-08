;; -*- lexical-binding: t; -*-

(use-package treesit
  :ensure nil
  :setopt
  (treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :setopt
  (treesit-auto-install 'prompt)
  :config

  (setq my-graphql-tsauto-config
      (make-treesit-auto-recipe
       :lang 'graphql
       :ts-mode 'graphql-ts-mode
       :remap 'graphql-mode
       :url "https://github.com/bkegley/tree-sitter-graphql"
       ;; :ext "\\.\\(graphql\\|gql\\)\\'"
       :ext "\\.graphql\\'"
       ))

  (add-to-list 'treesit-auto-recipe-list my-graphql-tsauto-config)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(provide 'treesit-settings)
