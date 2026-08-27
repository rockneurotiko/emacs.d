;;; treesit-settings.el --- Tree-sitter setup -*- lexical-binding: t; -*-

;;; Commentary:

;; Emacs 31 absorbed everything `treesit-auto' used to do for us, so that
;; package is no longer part of this config:
;;
;;   * Every built-in FOO-ts-mode registers `(foo-mode . foo-ts-mode)' in
;;     `treesit-major-mode-remap-alist' from its autoloads, and pins a grammar
;;     recipe (URL + :commit) in `treesit-language-source-alist'.
;;   * `treesit-enabled-modes' copies those remaps into
;;     `major-mode-remap-alist'.  It has to be set through `setopt' or
;;     Customize -- all the work happens in the option's :set function, a
;;     plain `setq' does nothing.
;;   * `treesit-auto-install-grammar' offers to build a missing grammar the
;;     first time a ts mode needs it, into the first writable directory of
;;     `treesit-extra-load-path', or ~/.emacs.d/tree-sitter when that is nil.
;;
;; Third-party ts modes that ship autoloads (hyprlang-ts-mode, md-ts-mode)
;; join `treesit-major-mode-remap-alist' the same way.  Ones that do not --
;; kitty-ts-mode below -- still need their own `auto-mode-alist' wiring.

;;; Code:

(use-package treesit
  :ensure nil
  :setopt
  (treesit-font-lock-level 4)
  ;; Prefer every available tree-sitter mode over its classic counterpart.
  ;; Use a list of ts-mode symbols instead of t to be selective.
  (treesit-enabled-modes t)
  ;; 'ask matches the old `treesit-auto-install' value of 'prompt.
  ;; Use 'always to build missing grammars without confirmation.
  (treesit-auto-install-grammar 'ask))

;; kitty.conf.  The grammar has no built-in or third-party Emacs mode, so
;; define one here.  Registered directly in `auto-mode-alist': a
;; `treesit-major-mode-remap-alist' entry would have to remap conf-mode,
;; which would hijack every other .conf file.
(use-package kitty-ts-mode
  :ensure nil
  :no-require t
  :after treesit
  :defines kitty-ts-mode

  :preface
  (defvar kitty-ts-mode--font-lock-settings
    (when (treesit-available-p)
      (treesit-font-lock-rules
       ;; Level 1: Comments
       :language 'kitty
       :feature 'comment
       '((comment) @font-lock-comment-face)

       ;; Level 2: Core structure
       :language 'kitty
       :feature 'keyword
       '((option_name) @font-lock-keyword-face
         (color_option_name) @font-lock-keyword-face)

       :language 'kitty
       :feature 'string
       '((string) @font-lock-string-face
         (path) @font-lock-string-face)

       ;; Level 3: Values and types
       :language 'kitty
       :feature 'constant
       '((constant) @font-lock-constant-face
         (boolean) @font-lock-constant-face)

       :language 'kitty
       :feature 'number
       '((number) @font-lock-number-face
         (pixel) @font-lock-number-face
         (percentage) @font-lock-number-face
         (time) @font-lock-number-face)

       :language 'kitty
       :feature 'color
       '((color) @font-lock-builtin-face)

       ;; Level 4: Shortcuts and actions
       :language 'kitty
       :feature 'shortcut
       '((keyboard_shortcut "map" @font-lock-keyword-face)
         (mouse_shortcut "mouse_map" @font-lock-keyword-face)
         (special) @font-lock-builtin-face
         (key) @font-lock-string-face
         (mouse_event) @font-lock-constant-face
         (mouse_mode) @font-lock-constant-face)

       :language 'kitty
       :feature 'action
       '((generic_action) @font-lock-function-name-face
         (action_name) @font-lock-function-name-face))))

  (define-derived-mode kitty-ts-mode prog-mode "Kitty"
    "Tree-sitter mode for kitty configuration files."
    (setq-local comment-start "# ")
    (setq-local comment-start-skip "#+\\s-*")
    (setq-local comment-end "")
    (setq-local indent-tabs-mode nil)
    ;; `treesit-ensure-installed' (new in 31) offers to build the grammar
    ;; when it is missing, honouring `treesit-auto-install-grammar'.
    (when (and (treesit-ensure-installed 'kitty)
               (treesit-ready-p 'kitty))
      (setq-local treesit-primary-parser (treesit-parser-create 'kitty))
      (setq-local treesit-font-lock-feature-list
                  '((comment)
                    (keyword string)
                    (constant number color)
                    (shortcut action)))
      (setq-local treesit-font-lock-settings
                  kitty-ts-mode--font-lock-settings)
      ;; The 'comment thing drives `forward-comment-function' in Emacs 31.
      (setq-local treesit-thing-settings
                  '((kitty (comment "\\`comment\\'"))))
      (treesit-major-mode-setup)))

  :init
  (add-to-list 'treesit-language-source-alist
               '(kitty "https://github.com/OXY2DEV/tree-sitter-kitty"))

  :config
  (add-to-list 'auto-mode-alist '("kitty\\.conf\\'" . kitty-ts-mode))
  (add-to-list 'auto-mode-alist '("/kitty/.*\\.conf\\'" . kitty-ts-mode)))

(use-package graphql-ts-mode
  :ensure t
  :config
  (add-to-list 'treesit-language-source-alist '(graphql "https://github.com/bkegley/tree-sitter-graphql"))
  (add-to-list 'major-mode-remap-alist '(graphql-mode . graphql-ts-mode))
  )

(provide 'treesit-settings)
;;; treesit-settings.el ends here
