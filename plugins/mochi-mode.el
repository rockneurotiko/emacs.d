;; (defvar mochi-mode-hook nil)

;; (add-to-list 'auto-mode-alist '("\\.mochi\\'" . mochi-mode))

;; (setq mochi-keywords '("import" "module" "require" "export" "var" "let" "def" "defm" "fn" "doc:" "try" "except" "as" "finally" "raise" "if" "then:" "else" "elif" "match" "receive" "of" "record" "data" "yield" "return" "with" "macro" "quote" "quasi_quote" "unquote" "unquote_splicing" "for" "in" "from" "end" "and" "or" "is" "not"))

;; (setq mochi-constants '("True" "False"))

;; (require 'generic-x) ;; we need this

;; (define-generic-mode 
;;     'mochi-mode                         ;; name of the mode to create
;;   '("#")                           ;; comments start with '!!'

;;   '("import" "module" "require" "export"
;;     "var" "let" "def" "defm" "fn" "doc:"
;;     "try" "except" "as" "finally" "raise"
;;     "if" "then:" "else" "elif" "match" "receive"
;;     "of" "record" "data" "yield" "return" "with"
;;     "macro" "quote" "quasi_quote" "unquote" "unquote_splicing"
;;     "for" "in" "from" "end" "and" "or" "is" "not") ;; keywords

;;   '(("=" . 'font-lock-operator)     ;; operators
;;     ("|>1?" 'font-lock-operator)
;;     ("|>1" 'font-lock-operator)
;;     ("|>?" 'font-lock-operator)
;;     ("\|>" 'font-lock-operator)
;;     ("!>" 'font-lock-operator)
;;     ("!&>" 'font-lock-operator)
;;     ("|" 'font-lock-operator)
;;     ("." 'font-lock-operator)
;;     ("%" 'font-lock-builtin)  ;; builtins
;;     ("->" 'font-lock-builtin)
;;     ("::" 'font-lock-builtin)
;;     (":" 'font-lock-builtin)
;;     ("^" 'font-lock-builtin)
;;     ("+" 'font-lock-builtin)
;;     ("-" 'font-lock-builtin)
;;     ("*" 'font-lock-builtin)
;;     ("/" 'font-lock-builtin)
;;     ("<=" 'font-lock-builtin)
;;     (">=" 'font-lock-builtin)
;;     ("==" 'font-lock-builtin)
;;     ("!=" 'font-lock-builtin)
;;     (">" 'font-lock-builtin)
;;     ("<" 'font-lock-builtin)
;;     ("!" 'font-lock-builtin)
;;     ("=" 'font-lock-builtin)
;;     (";" 'font-lock-builtin)
;;     ("@" 'font-lock-builtin)
;;     ("&" 'font-lock-builtin)
;;     ("\\" 'font-lock-builtin)
;;     )

;;   '("\\.mochi$")                      ;; files for which to activate this mode 
;;   nil                              ;; other functions to call
;;   "Simple syntax highlighting for mochi language"            ;; doc string for this mode
;;   )


;; (defvar mochi-cli-file-path "/usr/bin/mochi"
;;   "Path to the program used by `run-mochi'")

;; (defvar mochi-cli-arguments '()
;;   "Commandline arguments to pass to `mochi'")

;; (defvar mochi-mode-map
;;   (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
;;     ;; example definition
;;     (define-key map "\t" 'completion-at-point)
;;     map)
;;   "Basic mode map for `run-mochi'")

;; (defvar mochi-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)"
;;   "Prompt for `run-mochi'.")

;; (defun run-mochi ()
;;   "Run an inferior instance of `mochi' inside Emacs."
;;   (interactive)
;;   (let* ((mochi-program mochi-cli-file-path)
;;          (buffer (comint-check-proc "Mochi")))
;;     ;; pop to the "*Cassandra*" buffer if the process is dead, the
;;     ;; buffer is missing or it's got the wrong mode.
;;     (pop-to-buffer-same-window
;;      (if (or buffer (not (derived-mode-p 'mochi-mode))
;;              (comint-check-proc (current-buffer)))
;;          (get-buffer-create (or buffer "*Mochi*"))
;;        (current-buffer)))
;;     ;; create the comint process if there is no buffer.
;;     (unless buffer
;;       (apply 'make-comint-in-buffer "Mochi" buffer
;;              mochi-program mochi-cli-arguments)
;;       (mochi-mode))))

;; (defun mochi--initialize ()
;;   "Helper function to initialize Mochi"
;;   (setq comint-process-echoes t)
;;   (setq comint-use-prompt-regexp t))

;; (define-derived-mode mochi-mode comint-mode "Mochi"
;;   "Major mode for `run-mochi'.

;; \\<mochi-mode-map>"
;;   nil "Mochi"
;;   ;; this sets up the prompt so it matches things like: [foo@bar]
;;   (setq comint-prompt-regexp mochi-prompt-regexp)
;;   ;; this makes it read only; a contentious subject as some prefer the
;;   ;; buffer to be overwritable.
;;   (setq comint-prompt-read-only t)
;;   ;; this makes it so commands like M-{ and M-} work.
;;   (set (make-local-variable 'paragraph-separate) "\\'")
;;   ;;(set (make-local-variable 'font-lock-defaults) '(mochi-font-lock-keywords t))
;;   (set (make-local-variable 'paragraph-start) mochi-prompt-regexp))

;; ;; this has to be done in a hook. grumble grumble.
;; (add-hook 'mochi-mode-hook 'mochi--initialize)


(require 'generic-x)

(defvar mochi-keywords
  '("import" "module" "require" "export"
    "var" "let" "def" "defm" "fn" "doc:"
    "try" "except" "as" "finally" "raise"
    "if" "then:" "else" "elif" "match" "receive"
    "of" "record" "data" "yield" "return" "with"
    "macro" "quote" "quasi_quote" "unquote" "unquote_splicing"
    "for" "in" "from" "end" "and" "or" "is" "not") ;; keywords
  )  

(defvar mochi-tab-width 4 "Width of a tab for Mochi mode")

(defvar mochi-font-lock-defaults
  `((
     ("\"\\.\\*\\?" . font-lock-string-face)
     (";\\|\|>\\|!>\\[|\\]|\\|->\\|:=\\|(\\|)" . font-lock-keyword-face)
     ( ,(regexp-opt mochi-keywords 'words) . font-lock-builtin-face)
     ;;( ,(regexp-opt mochi-events 'words) . font-lock-constant-face)
     )))


(defvar mochi-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify_syntax_entry ?_ "_" table)
    (modify_syntax_entry ?# "< 14" table)
    (modify_syntax_entry ?\n ">" table)
    (modify-syntax-entry ?\{ "(} " table)
    (modify-syntax-entry ?\} "){ " table)
    (modify-syntax-entry ?\[ "(] " table)
    (modify-syntax-entry ?\] ")[ " table)
    (modify-syntax-entry ?\( "() " table)
    (modify-syntax-entry ?\) ")( " table)
    (modify-syntax-entry ?'  "." table)
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?` "\"" table)

    (modify-syntax-entry ?. "." table)
    (modify-syntax-entry ?? "." table)
    (modify-syntax-entry ?$ "." table)
    (modify-syntax-entry ?& "." table)
    (modify-syntax-entry ?* "." table)
    (modify-syntax-entry ?/ "." table)
    (modify-syntax-entry ?+ "." table)
    (modify-syntax-entry ?- "." table)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?% "." table)
    table)
  "Syntax table for `mochi-mode'.")

(defconst mochi-char-regex
  (rx (or (any "=" "|>1?" "|>1" "|>?" "\|>" "!>" "!&>" "|" "." "%" "->" "::" ":" "^" "+" "-" "*" "/" "<=" ">=" "==" "!=" ">" "<" "!" "=" ";" "@" "&" "\\")
          (syntax open-parenthesis)
          (syntax whitespace)
          bol)
      (group "'")
      (group
       (or (repeat 0 8 (not (any "'"))) (not (any "\\"))
           "\\\\"))
      (group "'")))

(defconst mochi-keyword-regex
  (mochi--regexp-opt
   '("import" "module" "require" "export"
     "var" "let" "def" "defm" "fn" "doc:"
     "try" "except" "as" "finally" "raise"
     "if" "then:" "else" "elif" "match" "receive"
     "of" "record" "data" "yield" "return" "with"
     "macro" "quote" "quasi_quote" "unquote" "unquote_splicing"
     "for" "in" "from" "end" "and" "or" "is" "not")
   'symbols))


(defconst mochi-block-start-keywords
  (list "if" "while" "for" "module" "try" "def" "match" "let" "macro"))

(defconst mochi-block-end-keywords
  (list "else" "elif" "except" "finally" "end"))


(define-derived-mode mochi-mode fundamental-mode "Mochi update"
  "Mochi mode is a major mode for Mochi language"

  (setq font-lock-defaults mochi-font-lock-defaults)
  (when mochi-tab-width
    (setq tab-width mochi-tab-width))

  ;;(setq comment-start "\"\"\"")
  ;;(setq comment-end "\"\"\"")

  (modify-syntax-entry ?# "< b" mochi-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" mochi-mode-syntax-table)
  )

(provide 'mochi-mode)
(add-to-list 'auto-mode-alist '("\\.mochi\\'" . mochi-mode))
