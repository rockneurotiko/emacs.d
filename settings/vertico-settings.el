(defun rock--up-directory (arg)
  "Move up a directory (delete backwards to /)."
  (interactive "p")
  (if (string-match-p "/." (minibuffer-contents))
      (zap-up-to-char (- arg) ?/)
    (delete-minibuffer-contents)))

(use-package vertico
  :ensure t
  :bind (
         :map minibuffer-mode-map
         ("<left>" . #'rock--up-directory)
         ("<right>" . vertico-insert)
         )
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  :init
  (vertico-mode 1))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (;; A recursive grep
         ("M-s M-g" . consult-ripgrep)
         ;; Search for files names recursively
         ("M-s M-f" . consult-find)
         ;; Search through the outline (headings) of the file
         ("M-s M-o" . consult-outline)
         ("M-s M-i" . consult-imenu)
         ;; Search the current buffer
         ("M-s M-l" . consult-line)
         ("M-g g" . consult-goto-line)
         ;; Switch to another buffer, or bookmarked file, or recently
         ;; opened file.
         ;; ("M-s M-b" . consult-buffer)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-l" . consult-line)                  ;; needed by consult-line to detect isearch
         )
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root)))
  (recentf-mode 1))

(use-package consult-lsp
  :ensure t
  :bind (
         :map lsp-mode-map
              ("M-s i" . consult-lsp-file-symbols)
              )
  :init
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  ;; (defun crm-indicator (args)
  ;;   (cons (format "[CRM%s] %s"
  ;;                 (replace-regexp-in-string
  ;;                  "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
  ;;                  crm-separator)
  ;;                 (car args))
  ;;         (cdr args)))
  ;; (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  ;; (setq minibuffer-prompt-properties
  ;;       '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)

  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

(provide 'vertico-settings)
