(use-package graphql-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook
    (graphql-mode . lsp)
  )

(provide 'graphql-settings)
