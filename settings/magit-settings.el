(use-package magit
  :ensure t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("C-c g" . magit-status)
	 ("C-c C-c" . with-editor-finish)
	 ("C-c C-k" . with-editor-cancel)))

(use-package magit-gh-pulls
  :ensure t
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(provide 'magit-settings)
