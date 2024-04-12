(use-package typescript-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

(use-package tss
  :ensure t
  :init
  (setq tss-popup-help-key "C-:")
  (setq tss-jump-to-definition-key "C->")
  (setq tss-implement-definition-key "C-c i")
  :config
  ;; Do setting recommemded configuration
  (tss-config-default))

;; (setq tss-module "commonjs")

(provide 'tss-settings)
