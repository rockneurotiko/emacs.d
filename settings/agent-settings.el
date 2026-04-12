(use-package track-changes
  :ensure (:source gnu-elpa))

(use-package copilot
  :ensure (copilot
              :host github
              :repo "copilot-emacs/copilot.el"
              :branch "main"
              :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-<tab>" . 'copilot-accept-completion)
              ;; ("TAB" . 'copilot-accept-completion)
              ;; ("C-TAB" . 'copilot-accept-completion-by-word)
              ("M-<tab>" . 'copilot-accept-completion-by-word)
              )
  :setopt
  (copilot-indent-offset-warning-disable t)

  ;; :setopt
  ;; (copilot-lsp-settings '(:github (:copilot (:selectedCompletionModel "claude-3.7-sonnet"))))
  ;; (copilot-log-max nil)
  ;; (copilot-server-log-level 4)
  )

(use-package claude-code :ensure (claude-code :host github :repo "stevemolitor/claude-code.el"))


(use-package claude-code-ide
  :ensure (claude-code-ide :host github :repo "manzaltu/claude-code-ide.el" :files ("*.el"))
  ;; :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :setopt
  (claude-code-ide-terminal-backend 'vterm)
  (claude-code-ide-enable-mcp-server t)
  :config
  (setenv "ANTHROPIC_AUTH_TOKEN" (efs/lookup-password :host "aider.chat" :user "anthropic"))
  (setenv "ANTHROPIC_BASE_URL" (efs/lookup-password :host "aider.chat" :user "anthropic-url"))

  ;; Optionally enable Emacs MCP tools
  (claude-code-ide-emacs-tools-setup))

(use-package agent-shell
  :ensure (agent-shell :host github :repo "xenodium/agent-shell" :files ("*.el"))
  :bind ("C-c C-'" . agent-shell)
  :ensure-system-package
  ;; Add agent installation configs here
  ((claude . "yay claude-code -Syu")
   (claude-code-acp . "npm install -g @zed-industries/claude-code-acp"))
  :setopt
  (agent-shell-anthropic-default-model-id "claude-4-5-sonnet")
  (agent-shell-prefer-viewport-interaction t)
  :config
  (setq agent-shell-anthropic-claude-environment
        (agent-shell-make-environment-variables
         :inherit-env t
         "ANTHROPIC_AUTH_TOKEN" (efs/lookup-password :host "aider.chat" :user "anthropic")
         "ANTHROPIC_MODEL" "claude-4-5-sonnet"
         "ANTHROPIC_BASE_URL" (efs/lookup-password :host "aider.chat" :user "anthropic-url")))
  )
;; Generic AI Code
;; (use-package ai-code
;;   :ensure (ai-code :host github :repo "tninja/ai-code-interface.el")
;;   :bind ("C-c C-'" . ai-code-menu) ;; Global keybinding for the main menu
;;   :setopt
;;   (claude-code-terminal-backend 'vterm) ;; for openai codex, github copilot cli, opencode; for claude-code-ide.el and gemini-cli.el, you can check their config
;;   :config
;;   (ai-code-set-backend  'claude-code-ide) ;; use claude-code-ide as backend
;;   (ai-code-set-backend  'opencode)
;;   ;; Optional: Turn on auto-revert buffer, so that the AI code change automatically appears in the buffer
;;   (global-auto-revert-mode 1)
;;   (setq auto-revert-interval 1) ;; set to 1 second for faster update
;;   ;; Optional: Set up Magit integration for AI commands in Magit popups
;;   (with-eval-after-load 'magit
;;     (ai-code-magit-setup-transients)))


(provide 'agent-settings)
