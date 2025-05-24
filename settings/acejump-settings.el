;; -*- lexical-binding: t; -*-
(use-package avy
  :ensure t
  :bind (("C-c SPC" . avy-goto-char-timer)
         ("M-g C-g" . avy-goto-line)))

(use-package ace-jump-mode
  :disabled t
  :ensure t
  :bind ("C-c SPC" . ace-jump-mode))

(provide 'acejump-settings)
