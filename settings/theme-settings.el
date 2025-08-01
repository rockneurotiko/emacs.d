;; -*- lexical-binding: nil; -*-

;; THEMES! :-)

(use-package nyan-mode
  :ensure t)

(use-package mood-line
  :ensure t
  :after nyan-mode
  ;; Enable mood-line
  :config
  (setq mood-line-format
        (mood-line-defformat
         :left
         (((mood-line-segment-modal)                  . " ")
          ((or (mood-line-segment-buffer-status) " ") . " ")
          ((mood-line-segment-buffer-name)            . "  ")
          ((mood-line-segment-anzu)                   . "  ")
          ((mood-line-segment-multiple-cursors)       . "  ")
          ((mood-line-segment-cursor-position)        . " ")
          ((mood-line-segment-scroll) . " ")
          (nyan-create)
          )
         :right
         (((mood-line-segment-vc)         . "  ")
          ((mood-line-segment-major-mode) . "  ")
          ((mood-line-segment-misc-info)  . "  ")
          ((mood-line-segment-checker)    . "  ")
          ((mood-line-segment-process)    . "  "))))

  ;; (setq mood-line-format mood-line-format-default)
  (mood-line-mode)

  ;; Use pretty Fira Code-compatible glyphs
  :custom
  ;; Can't use :setopt
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

(defun set-nord-theme ()
  (use-package nord-theme
    :ensure t
    :config
    (let ((class '((class color) (min-colors 89)))
          (nord0 (if (nord-display-truecolor-or-graphic-p) "#2E3440" nil))
          (nord1 (if (nord-display-truecolor-or-graphic-p) "#3B4252" "black"))
          (nord2 (if (nord-display-truecolor-or-graphic-p) "#434C5E" "#434C5E"))
          (nord3 (if (nord-display-truecolor-or-graphic-p) "#4C566A" "brightblack"))
          (nord4 (if (nord-display-truecolor-or-graphic-p) "#D8DEE9" "#D8DEE9"))
          (nord5 (if (nord-display-truecolor-or-graphic-p) "#E5E9F0" "white"))
          (nord6 (if (nord-display-truecolor-or-graphic-p) "#ECEFF4" "brightwhite"))
          (nord7 (if (nord-display-truecolor-or-graphic-p) "#8FBCBB" "cyan"))
          (nord8 (if (nord-display-truecolor-or-graphic-p) "#88C0D0" "brightcyan"))
          (nord9 (if (nord-display-truecolor-or-graphic-p) "#81A1C1" "blue"))
          (nord10 (if (nord-display-truecolor-or-graphic-p) "#5E81AC" "brightblue"))
          (nord11 (if (nord-display-truecolor-or-graphic-p) "#BF616A" "red"))
          (nord12 (if (nord-display-truecolor-or-graphic-p) "#D08770" "brightyellow"))
          (nord13 (if (nord-display-truecolor-or-graphic-p) "#EBCB8B" "yellow"))
          (nord14 (if (nord-display-truecolor-or-graphic-p) "#A3BE8C" "green"))
          (nord15 (if (nord-display-truecolor-or-graphic-p) "#B48EAD" "magenta")))

      (custom-theme-set-faces
       'nord
       `(minibuffer-prompt ((,class (:foreground ,nord8 :background ,nord3 :weight bold))))
     ))

    (load-theme 'nord :no-confirm)))

(defun set-yin-theme ()
  (use-package tao-theme
    :ensure t
    :config
    (load-theme 'tao-yin t)))

(defun set-full-paren ()
  (show-paren-mode t)
  (setq show-paren-style 'expression))

(use-package indent-bars
  :ensure t
  :straight (indent-bars :type git :host github :repo "jdtsmith/indent-bars")
  :setopt
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
