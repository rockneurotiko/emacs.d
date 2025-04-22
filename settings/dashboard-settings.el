(use-package dashboard
  :ensure t
  :after (nerd-icons)
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

  (setq dashboard-projects-backend 'projectile)

  (setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline
                                  dashboard-insert-footer))

  (setq dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 5)
                          (agenda    . 5)
                          (registers . 5)))

  (setq dashboard-navigation-cycle t)

  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  :bind
    ("C-x C-t" . dashboard-open)
  )

(provide 'dashboard-settings)
