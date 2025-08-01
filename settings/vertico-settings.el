(defun zap-to-char-save (arg char)
    "Zap to a character, but save instead of kill."
    (interactive "p\ncZap to char: ")
    (save-excursion
      (zap-to-char arg char)
      (yank)))

(defun rock--remove-last-kill-ring-entry ()
  (interactive)
  (when kill-ring
    (setq kill-ring (cdr kill-ring)))

  ;; (wl-delete-last)

  (when kill-ring-yank-pointer
    (setq kill-ring-yank-pointer kill-ring)))


(defun rock--up-directory (arg)
  "Move up a directory (delete backwards to /)."
  (interactive "pUp directory: ")
  (if (string-match-p "/." (minibuffer-contents))
      (progn
        (zap-up-to-char (- arg) ?/)
        (rock--remove-last-kill-ring-entry))
    (delete-minibuffer-contents)
    ))

(use-package vertico
  :ensure t
  :bind (
         :map minibuffer-mode-map
         ("<left>" . #'rock--up-directory)
         ("<right>" . vertico-insert)
         )
  :setopt
  (vertico-cycle t)
  (vertico-resize nil)
  :hook (after-init . vertico-mode))

;; (use-package vertico-posframe
;;   :straight (:host github :repo "tumashu/vertico-posframe" :files ("*.el"))
;;   :config
;;   (vertico-posframe-mode 1))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :hook (after-init . marginalia-mode))

(defun rock--get-region-text ()
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning) (region-end))))

(defun consult-ripgrep-single-file ()
    "Call `consult-ripgrep' for the current buffer (a single file)."
    (interactive)
    (let ((consult-project-function nil))
      (consult-ripgrep (list (shell-quote-argument buffer-file-name)) (rock--get-region-text))))

(defun consult-ripgrep-directory ()
    "Call `consult-ripgrep' for the current buffer (a single file)."
    (interactive)
    (let ((consult-project-function nil))
      (consult-ripgrep nil (rock--get-region-text))))

(defun consult-ripgrep-projectile ()
    "Call `consult-ripgrep' for projectile."
    (interactive)
    (let ((consult-project-function (lambda (_) (projectile-project-root))))
      (consult-ripgrep nil (rock--get-region-text))))

(use-package consult
  :ensure t
  :bind (;; A recursive grep
         ("M-s M-g" . consult-ripgrep)
         ("C-c r g" . consult-ripgrep-directory)
         ("C-c r f" . consult-ripgrep-single-file)
         ("C-c r p" . consult-ripgrep-projectile)
         ;; Search for files names recursively
         ("M-s M-f" . consult-find)
         ;; search through the outline (headings) of the file
         ("M-s M-o" . consult-outline)
         ("M-s M-i" . consult-imenu)
         ;; search the current buffer
         ("M-s M-l" . consult-line)
         ("M-g g" . consult-goto-line)
         ;; switch to another buffer, or bookmarked file, or recently
         ;; opened file.
         ;; ("m-s m-b" . consult-buffer)
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

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;;
   ("C-h b" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult-lsp
  :after lsp-mode
  :bind (:map lsp-mode-map ("M-s i" . consult-lsp-file-symbols))
  :init
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(use-package consult-eglot
  :ensure t
  :after eglot
  :bind ("M-s i" . consult-eglot-symbols))

(use-package consult-gh
  :ensure t
  :after consult)

;; (use-package consult-omni
;;   :straight (consult-omni :type git :host github :repo "armindarvish/consult-omni" :branch "main" :files (:defaults "sources/*.el"))
;;   :after (consult embark)
;;   :setopt
;;    ;; General settings that apply to all sources
;;   (consult-omni-show-preview t) ;;; show previews
;;   (consult-omni-preview-key "C-o") ;;; set the preview key to C-o
;;   :config
;;   ;; Load Sources Core code
;;   (require 'consult-omni-sources)
;;   ;; Load Embark Actions
;;   (require 'consult-omni-embark)

;;   (setq consult-omni-sources-modules-to-load
;;         '(consult-omni-apps consult-omni-calc consult-omni-buffer consult-omni-fd consult-omni-org-agenda consult-omni-youtube consult-omni-ripgrep consult-omni-gh consult-omni-projects))
;;   (consult-omni-sources-load-modules)

;;   (setq consult-omni-multi-sources '("calc"
;;                                      "File"
;;                                      "Buffer"
;;                                      ;; "Bookmark"
;;                                      "Apps"
;;                                      ;; "gptel"
;;                                      ;; "Brave"
;;                                      ;; "Dictionary"
;;                                      ;; "Google"
;;                                      ;; "Wikipedia"
;;                                      ;; "elfeed"
;;                                      ;; "mu4e"
;;                                      ;; "buffers text search"
;;                                      ;; "Notes Search"
;;                                      "Org Agenda"
;;                                      ;; "GitHub"
;;                                      "Projects"
;;                                      "YouTube"
;;                                      ;; "Invidious"
;;                                      ))

;;     (setq consult-omni-default-interactive-command #'consult-omni-multi)
;;   )


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
