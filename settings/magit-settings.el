;; -*- lexical-binding: t; -*-

(use-package magit
  :ensure t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  (setopt magit-format-file-function #'magit-format-file-nerd-icons)
  :bind (("C-c g" . magit-status)
	 ("C-c C-c" . with-editor-finish)
	 ("C-c C-k" . with-editor-cancel)))

(use-package forge
  :ensure t
  :after magit
  :config
  (setq forge-buffer-draft-p t))

;; (use-package transient-posframe
;;   :straight (:host github :repo "yanghaoxie/transient-posframe" :files ("*.el"))
;;   :config
;;   (transient-posframe-mode))

(use-package magit-gh-pulls
  :disabled t
  ;; :ensure t
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(use-package git-link
  :straight (:host github :repo "sshaw/git-link")
  :bind (("C-c C-l" . git-link)))

(provide 'magit-settings)
