(use-package chatgpt-shell
  :ensure t
  :custom
  (chatgpt-shell-anthropic-key
   (lambda ()
     (efs/lookup-password :host "aider.chat" :user "anthropic")))
  (chatgpt-shell-model-version "claude-3.5-sonnet-latest")
  )

(provide 'llm-settings)
