;; -*- lexical-binding: t; -*-

(defun rock/projectile-relative-path-buffer ()
  "Return the relative name of the current buffer."
  (file-relative-name buffer-file-name (projectile-project-root)))

(defun rock/projectile-relative-path-with-line-number ()
  "Return the relative name of the current buffer with the line number."
  (concat (rock/projectile-relative-path-buffer) ":" (number-to-string (line-number-at-pos))))

(defun rock/projectile-relative-path-kill-ring ()
  "Add to the kill ring the relative name of the current buffer."
  (interactive)
  (let ((path (rock/projectile-relative-path-buffer)))
    (kill-new path)
    (message path)))

(defun rock/projectile-relative-path-with-line-number-kill-ring ()
  "Add to the kill ring the relative name with the line number of the current buffer."
  (interactive)
  (let ((path (rock/projectile-relative-path-with-line-number)))
    (kill-new path)
    (message path)))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  :bind
  ("C-c w r" . 'rock/projectile-relative-path-kill-ring)
  ("C-c w l" . 'rock/projectile-relative-path-with-line-number-kill-ring)
  ("C-c w c" . projectile-find-file))

;; (use-package helm-projectile
;;   :ensure t
;;   :config
;;   (helm-projectile-on)
;;   :bind
;;   ("C-c r p" . helm-projectile-rg))

(use-package consult-projectile
  :ensure t
  :bind ("C-c r c" . consult-projectile))

(provide 'projectile-settings)
