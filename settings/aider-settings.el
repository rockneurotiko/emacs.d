;; -*- lexical-binding: t; -*-
(use-package aidermacs
  :straight (:host github :repo "MatthewZMD/aidermacs" :files ("*.el"))
  :config
  (setq aidermacs-args '("--no-auto-commits" "--model" "sonnet"))
  (setq aidermacs-backend 'comint)
  (setenv "ANTHROPIC_API_KEY" (efs/lookup-password :host "aider.chat" :login "anthropic"))
  (global-set-key (kbd "C-c i") 'aidermacs-transient-menu))

(provide 'aider-settings)
