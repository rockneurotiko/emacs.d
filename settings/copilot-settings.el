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

(provide 'copilot-settings)
