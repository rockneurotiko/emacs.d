;; -*- lexical-binding: t; -*-

;; RTX
(if (file-exists-p "~/.local/share/rtx/shims")
    (progn
      (add-to-list 'exec-path (expand-file-name "~/.local/share/rtx/shims"))
      (setenv "PATH" (concat (expand-file-name "~/.local/share/rtx/shims") ":" (getenv "PATH")))))

;; MISE
(if (file-exists-p "~/.local/share/mise/shims")
    (progn
      (add-to-list 'exec-path (expand-file-name "~/.local/share/mise/shims"))
      (setenv "PATH" (concat (expand-file-name "~/.local/share/mise/shims") ":" (getenv "PATH")))))

;; ASDF
(setenv "PATH" (concat (expand-file-name "~/.asdf/shims") ":" (expand-file-name "~/.asdf/bin") ":" (getenv "PATH")))

(provide 'asdf-settings)
