(setq lisp-body-indent 2)
;; (setq elisp-mode-indent-level 2)

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

(use-package "eldoc"
  :ensure t
  :diminish eldoc-mode
  :commands eldoc-mode
  :defer t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
    (add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
    (add-hook 'ielm-mode-hook 'eldoc-mode))
  :config (eldoc-mode t))

(define-key emacs-lisp-mode-map (kbd "C-c .") 'find-function-at-point)
(bind-key "C-c f" 'find-function)

;; (package-require 'rainbow-delimiters)
;; (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)


(provide 'elisp-settings)
