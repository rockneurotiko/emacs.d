;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "settings" user-emacs-directory))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ;; w/o this Emacs freezes when refreshing ELPA

;; Setup elpaca

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; use-package settings and :setopt command

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose nil)

(defun use-package-normalize/:setopt (_name keyword args)
  (mapcar
   (lambda (elt)
     (use-package-as-one (symbol-name keyword) (list elt)
       (lambda (label arg)
         (unless (and (consp arg) (use-package-non-nil-symbolp (car arg)))
           (use-package-error
            (format "%s must be a (<symbol> . <value>) or list of these"
                    label)))
         arg)))
   args))

(defun use-package-handler/:setopt (name _keyword args rest state)
  (use-package-concat
   `((,'setopt
      ,@(cl-loop for (variable value) in args
                 append `(,variable ,value))))
   (use-package-process-keywords name rest state)))


(setopt use-package-keywords
        (mapcan
         (lambda (kw)
           (cond
            ;; ((and (eq kw :if)
            ;;       (not (memq kw use-package-extras-conditional-keywords)))
            ;;  `(:if ,@use-package-extras-conditional-keywords))

            ((eq kw :after)
             `(:after :setopt))

            (t (list kw))))
         use-package-keywords))

;; install use-package support to elpaca
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package xref :ensure nil)

;; font settings

(defun font-exists-p (font)
  "check if font exists"
  (if (null (x-list-fonts font)) nil t))

(defvar rock/fontname "Sarasa Mono J Nerd Font")
(defvar rock/fontname-variable "Sarasa UI J Nerd Font")
(defun rock/set-font (fontsize)
  (set-face-attribute 'default nil
                      :family rock/fontname
                      :height fontsize
                      :weight 'normal
                      :width 'normal)

  (set-face-attribute 'fixed-pitch nil :family rock/fontname :height 1.0)
  (set-face-attribute 'variable-pitch nil :family rock/fontname-variable :height 1.0)

  (set-face-attribute 'mode-line nil :family rock/fontname :height 130))


(defun set-interview-fontsize ()
  (interactive)
  (rock/set-font 190))

(defun set-default-fontsize ()
  (interactive)
  (rock/set-font 140))

(defvar rock/delete-trailing-whitespace-excluded-modes
  '(makefile-mode markdown-mode org-mode)
  "Major modes in which `delete-trailing-whitespace-mode' should not be enabled.")

;; Define our own local minor mode for compatibility with Emacs <31
(define-minor-mode rock-delete-trailing-whitespace-mode
  "Minor mode to delete trailing whitespace on save."
  :lighter ""
  (if rock-delete-trailing-whitespace-mode
      (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
    (remove-hook 'before-save-hook #'delete-trailing-whitespace t)))

(defun rock/enable-delete-trailing-whitespace ()
  "Enable `delete-trailing-whitespace-mode' unless excluded."
  (unless (apply #'derived-mode-p rock/delete-trailing-whitespace-excluded-modes)
    (rock-delete-trailing-whitespace-mode 1)))

(defun add-point-to-find-tag-marker-ring (&rest r)
  "Advising function to use `find-tag-marker-ring' (R ignored)."
  (xref-push-marker-stack))

;;(define-globalized-minor-mode
;;      global-rock-delete-trailing-whitespace-mode
;;      delete-trailing-whitespace-mode
;;      rock/enable-delete-trailing-whitespace)

 (define-globalized-minor-mode
     global-rock-delete-trailing-whitespace-mode
     rock-delete-trailing-whitespace-mode
     rock/enable-delete-trailing-whitespace)

(use-package emacs :ensure nil
  :init
  (setopt use-short-answers t
        scroll-conservatively 101
        confirm-kill-emacs 'yes-or-no-p
        help-window-select t
        backup-by-copying t
        backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
        custom-file (expand-file-name "custom.el" user-emacs-directory)
        delete-old-versions t
        kept-new-versions 6
        kept-old-versions 2
        version-control t
        create-lockfiles nil
        enable-recursive-minibuffers t
        desktop-save-mode nil
        initial-scratch-message nil
        initial-major-mode 'text-mode
        initial-buffer-choice t
        inhibit-splash-screen t
        inhibit-startup-screen t
        inhibit-startup-message t
        custom-safe-themes t
        ring-bell-function #'ignore
        find-file-visit-truename t
        user-full-name "Rock Neurotiko"
        user-mail-address (concat "miguelglafuente" "@" "gmail" ".com")
        frame-title-format (concat "%b - " invocation-name "@" (system-name))
        text-mode-ispell-word-completion nil
        read-extended-command-predicate #'command-completion-default-include-p
        show-paren-style 'mixed

        completions-detailed t
        tab-always-indent 'complete
        completion-auto-help 'always
        completions-group t
        completion-auto-select 'second-tab

        mouse-wheel-tilt-scroll t
        mouse-wheel-flip-direction t


        )
  :config
  (setq-default truncate-lines t
                display-line-numbers-width 3
                indent-tabs-mode nil
                fill-column 80
                tab-width 4)

  (auto-save-visited-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (show-paren-mode 1)
  (blink-cursor-mode -1)
  (global-visual-line-mode 1)
  (global-display-line-numbers-mode 1)
  (pixel-scroll-precision-mode)
  (save-place-mode 1) ;; remember cursor position in files
  (prefer-coding-system 'utf-8)
  (fringe-mode '(8 . 8))
  (when (and (window-system) (font-exists-p rock/fontname))
    (set-frame-font rock/fontname)
    (set-default-fontsize))
  (global-rock-delete-trailing-whitespace-mode 1)
  (global-unset-key (kbd "C-h"))
  (global-unset-key (kbd "C-t"))
  (global-set-key (kbd "C-h") 'left-char)
  (global-set-key (kbd "C-t") 'right-char)

  :bind
  (("C-S-h m" . describe-mode)))

(use-package auth-source :ensure nil
  :setopt
  (auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))
  :init
  (defun efs/lookup-password (&rest keys)
    (let ((result (apply #'auth-source-search keys)))
      (if result
          (funcall (plist-get (car result) :secret))
        nil))))

(use-package plstore :ensure nil
  :init
  (setq plstore-encrypt-to nil)
  (add-to-list 'plstore-encrypt-to "7BEE07DBE45D6326"))

(use-package savehist :ensure nil
  :init
  (setq
   savehist-file (expand-file-name "savehist" user-emacs-directory)
   history-length t
   history-delete-duplicates t
   savehist-save-minibuffer-history t
   savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
  :hook (elpaca-after-init . savehist-mode))

(use-package recentf
  :ensure nil
  :hook (elpaca-after-init . recentf-mode)
  :custom
  (recentf-filename-handlers '(abbreviate-file-name))
  (recentf-max-saved-items 400)
  (recentf-max-menu-items 400)
  (recentf-save-file (expand-file-name "recentf" user-emacs-directory))
  :hook (elpaca-after-init . #'recentf-cleanup))

(use-package autorevert
  :ensure nil
  :hook (elpaca-after-init . global-auto-revert-mode))

(use-package winner :ensure nil
  :config
  (winner-mode t))

(when (>= emacs-major-version 31)
  (use-package window :ensure nil
    :bind
    ("C-x C-0" . rotate-windows-back)
    ("C-x C-1" . rotate-windows))
  )

(use-package recentf :ensure nil
  :init
  (recentf-mode 1))

(use-package uniquify
  :ensure nil
  :setopt
  (uniquify-buffer-name-style 'forward))

(defun rock/project-relative-path ()
  "Return the file path of the current buffer, relative to the project root.
If there’s no project or the buffer isn’t visiting a file, return nil."
  (when-let* ((file (buffer-file-name))
              (project (project-current))
              (root (project-root project)))
    (file-relative-name file root)))

(defun rock/project-relative-path-with-line-number ()
  "Return the project-relative file path of the current buffer with line number.
If there’s no project or file, return nil."
  (when-let* ((path (rock/project-relative-path)))
    (format "%s:%d" path (line-number-at-pos))))

(defun rock/project-relative-path-copy ()
  "Copy the project-relative file path of the current buffer to the kill ring."
  (interactive)
  (if-let* ((path (rock/project-relative-path)))
      (progn
        (kill-new path)
        (message "Copied: %s" path))
    (user-error "No project file path available")))

(defun rock/project-relative-path-with-line-number-copy ()
  "Copy the project-relative file path with line number to the kill ring."
  (interactive)
  (if-let* ((path (rock/project-relative-path-with-line-number)))
      (progn
        (kill-new path)
        (message "Copied: %s" path))
    (user-error "No project file path available")))

(defun rock/completions-reset-set (&rest completion-functions)
  "Reset completion-at-point-functions locally and add each function from COMPLETION-FUNCTIONS.
This function sets completion-at-point-functions to an empty list locally,
then adds each function from the arguments one by one using add-hook."
  (setq-local completion-at-point-functions nil)
  (cl-dolist (func completion-functions)
    (when (eq t (cond
                 ((fboundp func) t)
                 ((eq t func) t)
                 ((functionp func) t)
                 (t nil)))
      (add-hook 'completion-at-point-functions func 100 t)))
  )

(use-package project :ensure nil
  :bind (("C-c r P" . project-switch-project)
         ("C-c r k" . project-kill-buffers)
         ("C-c w r" . 'rock/project-relative-path-copy)
         ("C-c w l" . 'rock/project-relative-path-with-line-number-copy))

  :config
  (add-to-list 'vc-directory-exclusion-list "data/db")
  (add-to-list 'project-vc-extra-root-markers "mix.exs")

  (defun rock/project-auto-register ()
    "Ensure the current buffer's directory is registered as a project."
    (when (buffer-file-name)
      (when-let ((project (project-current nil)))
        (project-remember-project project))))

  (add-hook 'find-file-hook #'rock/project-auto-register)
  )

(defun rock/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'rock/keyboard-quit-dwim)

;; external dependencies

;; theme

(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config
  (load-theme 'doom-laserwave t)
  ;; (load-theme 'doom-nord t)
  ;; (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))

(use-package mood-line
  :ensure t
  :config
  (mood-line-mode)

  ;; (custom-set-faces '(mood-line-unimportant ((t (:inherit shadow :weight normal)))))

  ;; Use pretty Fira Code-compatible glyphs
  :custom
  ;; Can't use :setopt
  (mood-line-format mood-line-format-default)
  (mood-line-glyph-alist mood-line-glyphs-fira-code))


(use-package undo-fu
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; Ensure Elpaca updates transient to a compatible version for magit and claude-code-ide
(use-package transient
  :ensure t
  :demand t)

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)
	     ("C-c C-c" . with-editor-finish)
	     ("C-c C-k" . with-editor-cancel)))

(use-package git-link
  :ensure (git-link :host github :repo "sshaw/git-link")
  :bind (("C-c C-l" . git-link)))

;;-------------------;
;;; Auto-Complete ;;;
;;-------------------;

(use-package orderless
    :ensure t
    :config
    (setopt completion-styles '(orderless partial-completion basic initials substring)
          completion-category-defaults nil
          completion-category-overrides '((file (styles basic partial-completion))))
    )

(use-package corfu
   :ensure t
    :after orderless
    :setopt
    (corfu-quit-at-boundary nil)
    (corfu-quit-no-match t)
    (corfu-cycle t)
    (corfu-auto t)
    :init
    (global-corfu-mode))

;; Make corfu popup come up in terminal overlay
(when (< emacs-major-version 31)
  (use-package corfu-terminal
    :if (not (display-graphic-p))
    :ensure t
    :config
    (corfu-terminal-mode)))

(use-package kind-icon
  :if (display-graphic-p)
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :ensure t
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
          ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  ;; :hook (elpaca-after-init . (lambda () (progn
  :init

  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.

  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-emoji)

  :hook
  (prog-mode . (lambda ()
                 (rock/completions-reset-set
                  #'cape-dabbrev
                  #'cape-keyword
                  #'cape-file
                  t)))
  (emacs-lisp-mode . (lambda ()
                       (rock/completions-reset-set
                        #'cape-elisp-symbol
                        #'cape-elisp-block
                        #'cape-dabbrev
                        #'cape-keyword
                        #'cape-file
                        t))))

(use-package vertico
  :ensure t
  :bind (
         :map minibuffer-mode-map
              ("DEL" . vertico-directory-delete-char)
              ("<left>" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)
              ("<right>" . vertico-insert)
         )
  :setopt
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-count 15)
  :init
  (vertico-mode)
  )

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :hook (elpaca-after-init . marginalia-mode))

(defun rock--get-region-text ()
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning) (region-end))))

(defun consult-ripgrep-single-file ()
    "Call `consult-ripgrep' for the current buffer (a single file)."
    (interactive)
    (consult-ripgrep (list (shell-quote-argument buffer-file-name)) (rock--get-region-text))
    )

(defun consult-ripgrep-directory ()
    "Call `consult-ripgrep' for the current buffer's directory."
    (interactive)
    (consult-ripgrep `(,(file-name-directory buffer-file-name)) (rock--get-region-text))
    )

(use-package consult
  :ensure t
    :bind (;; A recursive grep
         ("C-c r p" . consult-ripgrep)
         ("C-c r g" . consult-ripgrep-directory)
         ("C-c r f" . consult-ripgrep-single-file)
         ("C-c r c" . consult-fd)
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
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-l" . consult-line)                  ;; needed by consult-line to detect isearch
         )
    :hook (completion-list-mode . consult-preview-at-point-mode)
    :setopt
    (consult-narrow-key "<")
    :init
      (advice-add 'consult-line :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-goto-line :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-ripgrep :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-ripgrep-directory :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-ripgrep-single-file :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-ripgrep-projectile :before 'add-point-to-find-tag-marker-ring)
      (advice-add 'consult-imenu :before 'add-point-to-find-tag-marker-ring)
)

(use-package move-text
  :ensure t
  :init
  (move-text-default-bindings)
  (defun rock/indent-region-advice (&rest ignored)
    (let ((deactivate deactivate-mark))
      (if (region-active-p)
          (indent-region (region-beginning) (region-end))
        (indent-region (line-beginning-position) (line-end-position)))
      (setq deactivate-mark deactivate)))

  (advice-add 'move-text-up :after 'rock/indent-region-advice)
  (advice-add 'move-text-down :after 'rock/indent-region-advice))

;; we start with meow even if it's external because it change how we use emacs
(require 'meow-settings)

(use-package avy
  :ensure t
  :bind (("C-c SPC" . avy-goto-char-timer)
         ("M-g C-g" . avy-goto-line)))


(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window))
  :setopt
  (aw-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))
  (aw-dispatch-alist
  '((?q aw-delete-window "Delete Window")
	(?m aw-swap-window "Swap Windows")
	(?M aw-move-window "Move Window")
	(?c aw-copy-window "Copy Window")
	(?r aw-switch-buffer-in-window "Select Buffer")
	(?w aw-flip-window)
	(?g aw-switch-buffer-other-window "Switch Buffer Other Window")
	(?4 aw-split-window-fair "Split Fair Window")
	(?3 aw-split-window-vert "Split Vert Window")
	(?2 aw-split-window-horz "Split Horz Window")
	(?l delete-other-windows "Delete Other Windows")
	(?? aw-show-dispatch-help))))


(use-package nerd-icons
  :ensure t
  :setopt
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons marginalia vertico)
  :config
  (nerd-icons-completion-mode)
  ;; (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  :hook
  (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after (nerd-icons corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))


(use-package dashboard
  :ensure t
  :after (nerd-icons)
  :custom
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline
                                  dashboard-insert-footer))
  :setopt
  ;; (initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

  (dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 5)
                          (agenda    . 5)
                          (registers . 5)))

  (dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)

  (dashboard-navigation-cycle t)

  (dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (dashboard-set-file-icons t)

  :hook
  (elpaca-after-init . dashboard-initialize)
  (elpaca-after-init . dashboard-insert-startupify-lists)

  :config
  (dashboard-setup-startup-hook)

  :bind
    ("C-x C-t" . dashboard-open))

(use-package helpful
  :ensure t
  :bind
        (("C-S-h f" . helpful-callable)
         ("C-S-h v" . helpful-variable)
         ("C-S-h k" . helpful-key)
         ("C-S-h x" . helpful-command)
         ("C-S-h F" . helpful-function)
         ("C-c C-d" . helpful-at-point)))

(use-package embark
  :ensure t
  :after (avy)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;;
   ("C-S-h b" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Add the option to run embark when using avy
  (defun rock/avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  ;; After invoking avy-goto-char-timer, hit "." to run embark at the next
  ;; candidate you select
  (setf (alist-get ?. avy-dispatch-alist) 'rock/avy-action-embark)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :after (embark consult)
  :init
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-M->" . mc/unmark-next-like-this)
         ("C-M-<" . mc/unmark-previous-like-this)
         ("C-c m a" . mc/mark-all-like-this)
         ("C-c m e" . mc/edit-lines)
         ("C-c m r" . mc/mark-all-in-region)
         ("C-c m d" . mc/mark-all-dwim)
         ("C-c m s" . mc/sort-regions)
         ("C-c m a" . mc/vertical-align-with-space)
         ))

(use-package phi-search
  :ensure t
  :bind (("C-s" . phi-search)
         ("C-S-s" . isearch-forward)
         ("C-r" . phi-search-backward)
         ("C-S-r" . isearch-backward)))

(use-package anzu
  :ensure t
  :diminish anzu-mode
  :config
  (global-anzu-mode +1)
  (global-set-key [remap query-replace] 'anzu-query-replace)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

  (custom-set-variables
   '(anzu-mode-lighter "")
   '(anzu-replace-to-string-separator " => ")
   )
  )

(use-package deadgrep
  :ensure t
  :bind (("C-c r C-g" . deadgrep)))

(use-package wgrep
  :ensure t
  :setopt
  (wgrep-auto-save-buffer t))

(use-package wgrep-deadgrep
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))


(use-package elixir-mode
  :ensure t)

(use-package exunit
  :ensure t
  :diminish exunit-mode
  :hook
  (elixir-mode . exunit-mode)
  (elixir-ts-mode . exunit-mode))

(use-package markdown-mode :ensure t)

(use-package graphql-mode :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package vterm
  :ensure t
  :setopt
  (vterm-shell "/usr/bin/fish")
  (vterm-max-scrollback 10000)
  :hook
  (vterm-mode . (lambda ()
                  (setq show-trailing-whitespace nil)
                  (when (featurep 'autopair-mode)
                    (autopair-mode -1))))
  :bind
  (:map vterm-mode-map
        ("C-y" . vterm-yank)))

(use-package copilot
  :ensure (copilot
              :host github
              :repo "copilot-emacs/copilot.el"
              :branch "main"
              :files ("dist" "*.el"))

  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-<tab>" . 'copilot-accept-completion)
              ;; ("TAB" . 'copilot-accept-completion)
              ;; ("C-TAB" . 'copilot-accept-completion-by-word)
              ("M-<tab>" . 'copilot-accept-completion-by-word)
              )
  :config
  (setq copilot-indent-offset-warning-disable t)

  ;; :setopt
  ;; (copilot-lsp-settings '(:github (:copilot (:selectedCompletionModel "claude-3.7-sonnet"))))
  ;; (copilot-log-max nil)
  ;; (copilot-server-log-level 4)
  )

(use-package claude-code-ide
  :ensure (claude-code-ide :host github :repo "manzaltu/claude-code-ide.el" :files ("*.el"))
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :setopt
  (claude-code-ide-terminal-backend 'vterm)
  (claude-code-ide-enable-mcp-server t)
  :config
  (setenv "ANTHROPIC_AUTH_TOKEN" (efs/lookup-password :host "aider.chat" :user "anthropic"))
  (setenv "ANTHROPIC_BASE_URL" (efs/lookup-password :host "aider.chat" :user "anthropic-url"))

  ;; Optionally enable Emacs MCP tools
  (claude-code-ide-emacs-tools-setup))

;; external settings except meow

(require 'org-settings)
(require 'treesit-settings)
(require 'eglot-settings)
