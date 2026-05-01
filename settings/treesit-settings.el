;; -*- lexical-binding: t; -*-

(use-package treesit
  :ensure nil
  :setopt
  (treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :setopt
  (treesit-auto-install 'prompt)
  :config

  (setq my-graphql-tsauto-config
      (make-treesit-auto-recipe
       :lang 'graphql
       :ts-mode 'graphql-ts-mode
       :remap 'graphql-mode
       :url "https://github.com/bkegley/tree-sitter-graphql"
       ;; :ext "\\.\\(graphql\\|gql\\)\\'"
       :ext "\\.graphql\\'"
       ))

  (add-to-list 'treesit-auto-recipe-list my-graphql-tsauto-config)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))


(use-package kitty-ts-mode
  :ensure nil
  :no-require t
  :after (treesit treesit-auto)
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
    (when (treesit-ready-p 'kitty)
      (treesit-parser-create 'kitty)
      (setq-local treesit-font-lock-feature-list
                  '((comment)
                    (keyword string)
                    (constant number color)
                    (shortcut action)))
      (setq-local treesit-font-lock-settings
                  kitty-ts-mode--font-lock-settings)
      (treesit-major-mode-setup)))

  :init
  (add-to-list 'treesit-language-source-alist
               '(kitty "https://github.com/OXY2DEV/tree-sitter-kitty"))
  ;; Register with treesit-auto if you want automatic grammar installation
  (add-to-list 'treesit-auto-recipe-list
               (make-treesit-auto-recipe
                :lang 'kitty
                :ts-mode 'kitty-ts-mode
                :remap 'conf-mode
                :url "https://github.com/OXY2DEV/tree-sitter-kitty"
                :revision "main"
                :source-dir "src"
                :ext "\\.conf\\'"))

  :config
  (add-to-list 'auto-mode-alist '("kitty\\.conf\\'" . kitty-ts-mode))
  (add-to-list 'auto-mode-alist '("/kitty/.*\\.conf\\'" . kitty-ts-mode))
  )



(provide 'treesit-settings)
