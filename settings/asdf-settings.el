;; RTX
(if (file-exists-p "~/.local/share/rtx/shims")
    (add-to-list 'exec-path (expand-file-name "~/.local/share/rtx/shims"))
  nil)

;; MISE
(if (file-exists-p "~/.local/share/mise/shims")
    (add-to-list 'exec-path (expand-file-name "~/.local/share/mise/shims"))
  nil)

;; ASDF
(setenv "PATH" (concat (expand-file-name "~/.asdf/shims") ":" (expand-file-name "~/.asdf/bin") ":" (getenv "PATH")))

(provide 'asdf-settings)
