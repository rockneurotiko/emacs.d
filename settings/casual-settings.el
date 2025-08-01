(use-package bookmark
  :ensure nil
  :defer t)


(use-package casual-suite
  :ensure t
  :after (bookmark hl-line)
  :bind
  ;; Isearch
  (:map isearch-mode-map
              ("C-o" . #'casual-isearch-tmenu))

  ;; Dired
  (:map dired-mode-map
              ("C-o" . #'casual-dired-tmenu)
              ("s" . #'casual-dired-sort-by-tmenu))

  ;; Bookmark
  (:map bookmark-bmenu-mode-map
              ("C-o" . casual-bookmarks-tmenu)
              ("?" . casual-bookmarks-tmenu)
              ("S" . casual-bookmarks-sortby-tmenu)
              ("J" . bookmark-jump))

  :config
  (setq bookmark-save-flag 1)
  (add-hook 'bookmark-bmenu-mode-hook #'hl-line-mode)
  )


(use-package casual-avy
  :ensure t
  :bind ("M-g m" . casual-avy-tmenu))

(provide 'casual-settings)
