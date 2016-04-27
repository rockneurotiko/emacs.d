(use-package org-tree-slide
  :ensure t
  :config
  (define-key org-tree-slide-mode-map (kbd "C-M-<left>")
    'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "C-M-<right>")
    'org-tree-slide-move-next-tree)

  (define-key org-tree-slide-mode-map (kbd "<f9>")
    'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>")
    'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "<f11>")
    'org-tree-slide-content)
  (define-key org-tree-slide-mode-map (kbd "C-c C-t")
    'org-tree-slide-play-with-timer)

  (org-tree-slide-narrowing-control-profile)
  (setq org-tree-slide-skip-outline-level 0)
  (setq org-tree-slide-header t)
  (setq org-tree-slide-slide-in-effect nil)
  (setq org-tree-slide-heading-emphasis t)
  (setq org-tree-slide-activate-message "Let's go Rock! <3")
  (setq org-tree-slide-deactivate-message "I hope that it went well ^^")
  (setq org-tree-slide-modeline-display 'outside)
  (setq org-tree-slide-skip-done nil)
  :bind (("<f8>" . org-tree-slide-mode)
         ("S-<f8>" . org-tree-slide-skip-done)))

(use-package org-present
  :disabled t
  :ensure t
  :config
  (add-hook 'org-present-mode-hook
            (lambda ()
              (org-present-big)
              (org-display-inline-images)
              (org-present-hide-cursor)
              (org-present-read-only)))
  (add-hook 'org-present-mode-quit-hook
            (lambda ()
              (org-present-small)
              (org-remove-inline-images)
              (org-present-show-cursor)
              (org-present-read-write))))

(provide 'presentation-settings)
