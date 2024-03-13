(defun rock/projectile-relative-name-buffer ()
  "Add to the kill ring the relative name of the current buffer."
  (interactive)
  (let ((path (file-relative-name buffer-file-name (projectile-project-root))))
    (kill-new path)
    (message path)))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  :bind
  ("C-c w r" . 'rock/projectile-relative-name-buffer))


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
