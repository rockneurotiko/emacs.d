;; -*- lexical-binding: t; -*-


;; After new installation, execute `M-x copilot-install-server` and restart

(use-package copilot
  :straight '(copilot
              :type git
              :host github
              :repo "zerolfx/copilot.el"
              :branch "main"
              :files ("dist" "*.el"))

  ;;  :quelpa (copilot :fetcher github
  ;;                   :repo "zerolfx/copilot.el"
  ;;                   :branch "main"
  ;;                   :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t))

(use-package shell-maker
  :ensure t)

(use-package copilot-chat
  :ensure t
  :after (request org markdown-mode shell-maker)
  ;; :config
  ;; (setq copilot-chat-frontend 'markdown)
  )


(provide 'copilot-settings)
