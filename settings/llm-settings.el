;; -*- lexical-binding: nil; -*-

(use-package chatgpt-shell
  :ensure t
  :setopt
  (chatgpt-shell-anthropic-key
   (lambda ()
     (efs/lookup-password :host "aider.chat" :user "anthropic")))
  (chatgpt-shell-model-version "claude-3.5-sonnet-latest")
  )

(use-package claude-code
  :ensure t
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main"
                   :files ("*.el" (:exclude "demo.gif")))
  :bind-keymap
  ("C-c I" . claude-code-command-map)
  :config

  (setenv "ANTHROPIC_API_KEY" (efs/lookup-password :host "aider.chat" :user "anthropic"))
  ;; (setenv "ANTHROPIC_AUTH_TOKEN" (efs/lookup-password :host "aider.chat" :user "anthropic"))
  (claude-code-mode))

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el" :files ("*.el"))
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (setenv "ANTHROPIC_API_KEY" (efs/lookup-password :host "aider.chat" :user "anthropic"))
  ;; Optionally enable Emacs MCP tools
  (claude-code-ide-emacs-tools-setup))


(provide 'llm-settings)
