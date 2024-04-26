;; (setq lsp-bridge-elixir-lsp-server "lexical")

(setq lsp-keymap-prefix "M-s")
(setq lsp-elixir-ls-version "v0.20.0")

(use-package lsp-mode
  :ensure t
  :hook (
         (elixir-mode . lsp)
         (elixir-ts-mode . lsp)
         (graphql-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  ;; (add-to-list 'exec-path "~/.emacs.d/settings/elixir-ls/elixir-1.15")

  ;; (add-hook 'elixir-mode-hook
  ;;           (lambda ()
  ;;             (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

  (add-hook 'elixir-ts-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'lsp-format-buffer t t)))


  :config
  (setq lsp-enable-file-watchers nil)
  (setq lsp-elixir-suggest-specs nil)
  (setq lsp-modeline-code-actions-segments '(count icon name))
  :custom
  (lsp-elixir-server-command '("/home/rock/Git/lexical/_build/dev/package/lexical/bin/start_lexical.sh"))
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-enable t
        lsp-ui-peek-enable t
        lsp-completion-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-header nil
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil))

;; LSP BOOSTER :rocket:
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))

(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; END LSP BOOSTER :rocket:

;; (setenv "PATH" (concat (expand-file-name "~/Git/lexical/_build/dev/package/lexical/bin") ":" (getenv "PATH")))

;; (use-package helm-lsp
;;   :ensure t
;;   :diminish lsp-mode
;;   :commands helm-lsp-workspace-symbol)

(provide 'lsp-settings)
