(use-package avy
  :ensure t
  :bind (("C-c SPC" . avy-goto-char)
         ("C-c C-l" . avy-goto-line)))

(use-package ace-jump-mode
  :disabled t
  :ensure t
  :bind ("C-c SPC" . ace-jump-mode))

(provide 'acejump-settings)
