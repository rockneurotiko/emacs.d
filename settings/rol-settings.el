(use-package decide
  :ensure t)

(defun rol-mode ()
  (interactive)
  (let ((bufrol (generate-new-buffer "[ROL]")))
    (switch-to-buffer bufrol)
    (funcall (and 'org-mode))
    (decide-mode)))

(provide 'rol-settings)
