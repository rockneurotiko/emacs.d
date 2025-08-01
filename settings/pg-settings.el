
(use-package pg
  :straight '(pg :type git :host github :repo "emarsden/pg-el" :branch "main" :files ("*.el")))

(use-package pgmacs
  :after pg
  :ensure pt
  :defer t
  :straight '(pgmacs :type git :host github :repo "emarsden/pgmacs" :branch "main" :files ("*.el")))

(provide 'pg-settings)
