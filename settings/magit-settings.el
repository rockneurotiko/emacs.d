(use-package magit
  :ensure t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("C-c g" . magit-status)
	 ("C-c C-c" . with-editor-finish)
	 ("C-c C-k" . with-editor-cancel)))

;; (use-package magit-gh-pulls
;;   :ensure t
;;   :config
;;   (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

;;(use-package magithub
;;  :ensure t
;;  :after magit
;;  :config
;;  (magithub-feature-autoinject t)
;;  (setq ghub-username "rockneurotiko")
;;  (setq ghub-token "bada7ea931e13e944a838e66210aecf02ea9ed30"))

(provide 'magit-settings)
