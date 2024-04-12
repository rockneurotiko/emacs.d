;; (setq lsp-bridge-elixir-lsp-server "lexical")

(setq lsp-keymap-prefix "M-s")
(setq lsp-elixir-ls-version "v0.20.0")

(use-package lsp-mode
  :ensure t
  :hook (
   (elixir-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  ;; (add-to-list 'exec-path "~/.emacs.d/settings/elixir-ls/elixir-1.15")

  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

  (setq lsp-enable-file-watchers nil)

  ;; :custom
  ;; (lsp-elixir-server-command '("/Users/mgarcial/Git/lexical/_build/dev/package/lexical/bin/start_lexical.sh"))
  )



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

;; (use-package lsp-ui :commands lsp-ui-mode)

(use-package helm-lsp
  :ensure t
  :diminish lsp-mode
  :commands helm-lsp-workspace-symbol)

(provide 'lsp-settings)
