;;; Code:

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (delete 'company-etags company-backends)
  (delete 'company-gtags company-backends)
  ;; https://github.com/mattfidler/auto-indent-mode.el/issues/65
  (advice-remove 'beginning-of-visual-line #'ad-Advice-move-beginning-of-line))

(provide 'company-settings)
;;; company-settings.el ends here
