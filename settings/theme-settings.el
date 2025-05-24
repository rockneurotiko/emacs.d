;; -*- lexical-binding: t; -*-

;; THEMES! :-)

(use-package mood-line
  :ensure t
  ;; Enable mood-line
  :config
  (setq mood-line-format mood-line-format-default)
  (mood-line-mode)

  ;; Use pretty Fira Code-compatible glyphs
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

(defun set-darkokai ()
  ;; Dark with red and green
  (use-package darkokai-theme
    :ensure t
    :config (load-theme 'darkokai t)))

(defun set-catppuccin ()
  (use-package catppuccin-theme
    :ensure t
    :init
    (setq catppuccin-flavor 'frappe) ;; 'latte, 'frappe, 'macchiato, or 'mocha
    ;; (catppuccin-reload)
    (load-theme 'catppuccin :no-confirm)
    ))

(defun set-ef-theme ()
  (use-package ef-themes
    :ensure t
    :init

    (setq ef-themes-to-toggle '(ef-summer ef-dream))

    ;; They are nil by default...
    (setq ef-themes-mixed-fonts t
          ef-themes-variable-pitch-ui t)

    ;; Disable all other themes to avoid awkward blending:
    (mapc #'disable-theme custom-enabled-themes)

    ;; Load the theme of choice:
    (load-theme 'ef-dream :no-confirm)))

(defun set-full-paren ()
  (show-paren-mode t)
  (setq show-paren-style 'expression))

(use-package indent-bars
  :ensure t
  :straight (indent-bars :type git :host github :repo "jdtsmith/indent-bars")
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed
  ;; (indent-bars-treesit-scope '((elixil function_definition class_definition for_statement
  ;;         if_statement with_statement while_statement)))
  ;; Note: wrap may not be needed if no-descend-list is enough
  (indent-bars-treesit-wrap '((elixir-ts do_block)))

  ;; (setq
  ;;   indent-bars-color '(highlight :face-bg t :blend 0.15)
  ;;   indent-bars-pattern "."
  ;;   indent-bars-width-frac 0.1
  ;;   indent-bars-pad-frac 0.1
  ;;   indent-bars-zigzag nil
  ;;   indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1) ; blend=1: blend with BG only
  ;;   indent-bars-highlight-current-depth '(:blend 0.5) ; pump up the BG blend on current
  ;;   indent-bars-display-on-blank-lines t)
  :hook ((nxml-mode yaml-mode elixir-ts-mode) . indent-bars-mode))

;; Instantly but if start maximized, then minimize
(toggle-frame-maximized)
;; Maximize at end
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))
(provide 'theme-settings)
