(use-package ponylang-mode
  :ensure t
  :config
  (add-hook 'ponylang-mode-hook
            (lambda ()
              (setq auto-indent-newline-function 'newline-and-indent)
              (setq tab-width 2)
              (auto-indent-mode -1)
              (electric-indent-local-mode -1))))

(provide 'pony-settings)
