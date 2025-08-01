;; -*- lexical-binding: t; -*-

(use-package undo-tree
  ;; :disabled t
  :ensure t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  :bind (("C-z" . undo-tree-undo)
         ("C-S-z" . undo-tree-redo)))

(use-package ultra-scroll
  :straight (ultra-scroll :host github :repo "jdtsmith/ultra-scroll")
  :setopt
  (scroll-conservatively 101) ; important!
  (scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(use-package helpful
  :ensure t
  :defer t
  :bind
        (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-h F" . helpful-function)
         ("C-c C-d" . helpful-at-point)))

(use-package bufferfile
  :ensure t
  :straight (bufferfile
             :type git
             :host github
             :repo "jamescherti/bufferfile.el")
  :setopt
  (bufferfile-use-vc t))

(use-package persist-text-scale
  :ensure t
  :straight (persist-text-scale
             :type git
             :host github
             :repo "jamescherti/persist-text-scale.el")
  :setopt
  ;; Time interval, in seconds, between automatic saves of text scale data.
  ;; If set to an integer value, enables periodic autosaving of persisted text
  ;; scale information at the specified interval.
  ;; If set to nil, disables timer-based autosaving entirely.
  (persist-text-scale-autosave-interval (* 7 60))
  ;; :config
  ;; persist-text-scale-mode)
   )

(use-package snap-indent
  :ensure t
  :config
  (add-to-list 'snap-indent-excluded-modes 'elixir-mode)
  (add-to-list 'snap-indent-excluded-modes 'elixir-ts-mode)
  :setopt
  (snap-indent-format 'untabify)
  (snap-indent-on-save t))

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode +1)
  (set-face-foreground 'git-gutter:modified "purple"))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings))

(use-package plantuml-mode
  :disabled t
  ;; :ensure t
  :init
  (setq org-plantuml-jar-path (expand-file-name "/opt/plantuml/plantuml.jar"))
  (setq plantuml-jar-path (expand-file-name "/opt/plantuml/plantuml.jar"))
  :config
  (org-babel-do-load-languages
   ;; active Org-babel languages
   'org-babel-load-languages
   '(;; other Babel languages
     (plantuml . t)))
  ;; Enable puml-mode for PlantUML files
  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode)))

;; (use-package smooth-scrolling
;;   :ensure t
;;   :init
;;   (smooth-scrolling-mode 1))

(use-package indent-guide
  :disabled t
  :ensure t
  :init (setq indent-guide-recursive t)
  :config (indent-guide-global-mode))

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

;; (use-package which-key
;;   :ensure t
;;   :straight (:type built-in)
;;   :diminish which-key-mode
;;   :setopt
;;   (which-key-popup-type 'side-window)
;;   (which-key-side-window-max-width 120)
;;   (which-key-side-window-max-height 50)
;;   :config
;;   (which-key-mode)
;;   (which-key-setup-side-window-right))


;; (use-package which-key-posframe
;;   :straight (:host github :repo "yanghaoxie/which-key-posframe" :files ("*.el"))
;;   :config
;;   (which-key-posframe-mode)
;;   (setq which-key-posframe-poshandler 'posframe-poshandler-frame-bottom-center))

;; (use-package mini-ontop
;;   :straight (:host github :repo "hkjels/mini-ontop.el" :files ("*.el"))
;;   :config (mini-ontop-mode 1))

;; (use-package discover-my-major
;;   :ensure t
;;   :bind (("c-h m-m" . discover-my-major)
;;          ("c-h m-s-m" . discover-my-mode)))

;; (use-package helm-systemd
;;   :ensure t)

(use-package odf-mode
  :disabled t
  :ensure t)

(use-package miniedit
  :defer t
  :ensure t
  :commands minibuffer-edit
  :init (miniedit-install))

(use-package switch-window
  :ensure t
  :bind (("C-x o" . switch-window))
  :setopt
  (switch-window-minibuffer-shortcut ?z))

(use-package swap-buffers
  :ensure t
  :bind (("C-x C-b" . swap-buffers)))

;; (use-package ranger
;;   :ensure t
;;   :init
;;   (setq ranger-parent-depth 2)
;;   (setq ranger-excluded-extensions '("mkv" "iso" "mp4" "mp3"))
;;   (setq ranger-max-preview-size 10)
;;   (setq ranger-override-dired t)
;;   :bind ("C-c d" . ranger))



(use-package dired
  :config
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)


  :setopt
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("i" "~/Git/itinerary-core/"     "Itinerary core")
     ("d" "~/Git/dotfiles/"     "Dotfiles")
     ("g" "~/Git"     "Git")
     ("o" "~/Git/orgs/roam/"     "Org files")
     ;; ("m" "/mnt/"                       "Drives")
     ;; ("e" "/sudo:root@localhost:/etc")  "Modify program settings"
     ))

  :config
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c d" . dirvish)
   :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("i"   . dirvish-file-info-menu)    ; file [i]nfo
   ("f"   . dirvish-fd-switches-menu)   ; [f]d switches
   ("j"   . dirvish-fd-jump)      ; [r]ecent visited
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("/"   . dirvish-fd)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu))
  )

(require 'dirvish)
(dirvish-define-preview
 eza
 (file)
 "Use `eza' to generate directory preview."
 :require ("eza") ; tell Dirvish to check if we have the executable
 (when (file-directory-p file) ; we only interest in directories here
   `(shell . ("eza" "-al" "--color=always" "--icons=always"
              "--group-directories-first" ,file))))

(push 'eza dirvish-preview-dispatchers)


(use-package deadgrep
  :ensure t
  :bind (("C-c r C-g" . deadgrep)))

(use-package wgrep-deadgrep
  :ensure t)


;; (use-package dired-subtree
;;   :ensure t
;;   :after dired
;;   :bind
;;   ( :map dired-mode-map
;;     ("<tab>" . dired-subtree-toggle)
;;     ("TAB" . dired-subtree-toggle)
;;     ("<backtab>" . dired-subtree-remove)
;;     ("S-TAB" . dired-subtree-remove))
;;   :config
;;   (setq dired-subtree-use-backgrounds nil))

;; (use-package float-narrow-indirect
;;   :straight (:host github :repo "yibie/float-narrow-indirect" :files ("*.el"))
;;   :bind
;;   (("C-c n f" . fni-narrow-to-region-floating)
;;    ("C-c n t" . fni-toggle-focus)
;;    ("C-c n c" . fni-clear-aggregation)))

(use-package smartscan
  :ensure t
  :config (global-smartscan-mode t))

;; (use-package outline-presentation
;;     ;; :disabled t
;;     :defer t
;;     :ensure t
;;     :init
;;     (add-to-list 'auto-mode-alist '("\\.outline\\'" . outline-mode))
;;     (add-hook 'outline-presentation-mode-hook
;;               (lambda () (text-scale-increase 3))))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode)
  (sp-with-modes 'elixir-ts-mode
    (sp-local-pair "do" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "def" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "defp" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "defmodule" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "fn" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "if" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "case" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "for" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "cond" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "try" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "receive" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "quote" "end" :actions '(wrap autoskip navigate))
    (sp-local-pair "defmacro" "end" :actions '(wrap autoskip navigate)))
  :hook
  (prog-mode . turn-on-smartparens-mode)
  (markdown-mode . turn-on-smartparens-strict-mode)
  :bind
  (("C-M-a" . sp-beginning-of-sexp)
   ("C-M-e" . sp-end-of-sexp)
   ("C-M-<down>" . sp-down-sexp)
   ("C-M-<up>" . sp-up-sexp)
   ("M-<down>" . sp-backward-down-sexp)
   ("M-<up>" . sp-backward-up-sexp)
   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("M-<backspace>" . backward-kill-word)
   ("C-<backspace>" . sp-backward-kill-word)
   ([remap sp-backward-kill-word] . backward-kill-word)))

(use-package emojify
  :ensure t
  :diminish emojify-mode
  :config
  (global-emojify-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package delsel
  :ensure t
  :straight (:type built-in)
  :hook (after-init . delete-selection-mode))

(use-package uniquify
  :ensure t
  :straight (:type built-in)
  :setopt
  (uniquify-buffer-name-style 'forward))

;; (defun set-buffer-expose ()
;;   (load "~/.emacs.d/plugins/buffer-expose/buffer-expose.el")
;;   (require 'buffer-expose)
;;   (buffer-expose-mode 1)

;;   (defvar buffer-expose-mode-map
;;     (let ((map (make-sparse-keymap)))
;;       (define-key map (kbd "<s-tab>") 'buffer-expose)
;;       (define-key map (kbd "<C-tab>") 'buffer-expose-no-stars)
;;       (define-key map (kbd "C-c <C-tab>") 'buffer-expose-current-mode)
;;       (define-key map (kbd "C-c C-d") 'buffer-expose-dired-buffers)
;;       (define-key map (kbd "C-c C-*") 'buffer-expose-stars)
;;       map)
;;     "Mode map for command `buffer-expose-mode'."))

(defun use-terraform ()
  (use-package terraform-mode
    :ensure t
    :disabled t
    :config
    (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)))

(provide 'random-requires)
