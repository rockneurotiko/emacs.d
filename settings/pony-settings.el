(use-package ponylang-mode
  :ensure t
  :config
  (add-hook 'ponylang-mode-hook
            (lambda ()
              (set-variable 'indent-tabs-mode nil)
              (set-variable 'tab-width 2)
              (setq auto-indent-newline-function 'newline-and-indent)
              (auto-indent-mode -1)
              (electric-indent-local-mode -1))))

(provide 'pony-settings)
