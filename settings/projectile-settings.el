(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  :bind
  ("C-c r p" . helm-projectile-rg)
  ("C-c r c" . helm-projectile-find-file))

;; (use-package consult-projectile
;;   :ensure t
;;   :bind ("C-c r c" . consult-projectile))

(provide 'projectile-settings)
