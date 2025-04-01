;; THEMES! :-)
;; Functions to apply themes :)

(defun random-elt (choices)
  "Choose an element from a list at random."
  (elt choices (random (length choices))))

(use-package mood-line
  :ensure t
  ;; Enable mood-line
  :config
  (setq mood-line-format mood-line-format-default)
  (mood-line-mode)

  ;; Use pretty Fira Code-compatible glyphs
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

(defun set-random-theme ()
  ;; Select one random from:
  ;; [spolsky, granger, cyberpunk, ample, grandshell, monokai, sanityinc-tomorrow-night, sanityinc-tomorrow-eighties]
  (load-theme
   (random-elt
    '(spolsky
      granger
      cyberpunk
      ample
      grandshell
      monokai
      sanityinc-tomorrow-night
      sanityinc-tomorrow-eighties)) t))


(defun set-darkokai ()
  (use-package darkokai-theme
    :ensure t
    :config (load-theme 'darkokai t)))

(defun set-cyberpunk ()
  (use-package cyberpunk-theme
    :ensure t
    :config (load-theme 'cyberpunk t)))

(defun set-sanityinc ()
  (use-package color-theme-sanityinc-tomorrow
    :ensure t
    :config
    (color-theme-sanityinc-tomorrow-eighties)))

(defun set-catppuccin ()
  (straight-use-package 'catppuccin-theme)
  (setq catppuccin-flavor 'frappe) ;; 'latte, 'frappe, 'macchiato, or 'mocha
  ;; (catppuccin-reload)
  (load-theme 'catppuccin :no-confirm))

;; Moe Worth!
(defun set-moe ()
  (use-package moe-theme
  :ensure t
  :config
  (powerline-moe-theme)
  (moe-dark)
  (moe-theme-set-color 'magenta)))

(defun set-full-paren ()
  (show-paren-mode t)
  (setq show-paren-style 'expression))

(use-package indent-bars
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
