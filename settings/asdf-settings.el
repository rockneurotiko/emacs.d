(setenv "PATH" (concat (expand-file-name "~/.asdf/shims") ":" (expand-file-name "~/.asdf/bin") ":" (getenv "PATH")))

(provide 'asdf-settings)
