(use-package undo-tree
  ;; :disabled t
  :defer t
  :ensure t
  :diminish undo-tree-mode
  :init (defalias 'redo 'undo-tree-redo)
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  :bind (("C-z" . undo)
         ("C-S-z" . redo)))

(use-package auto-indent-mode
  ;; :disabled t
  :ensure t
  :config
  (auto-indent-global-mode)
  (setq tab-width 4)
  (add-to-list 'auto-indent-disabled-modes-list 'ponylang-mode)
  (add-to-list 'auto-indent-disabled-modes-list 'python-mode)
  ;;(add-to-list 'auto-indent-disabled-modes-list 'elixir-mode)
)

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode +1)
  (set-face-foreground 'git-gutter:modified "purple"))

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

(use-package smooth-scrolling
  :ensure t)

;; (use-package auto-complete
;;   :ensure t
;;   :config (global-auto-complete-mode t))

(use-package indent-guide
  :disabled t
  :ensure t
  :init (setq indent-guide-recursive t)
  :config (indent-guide-global-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right))

(use-package discover-my-major
  :ensure t
  :bind (("C-h M-m" . discover-my-major)
         ("C-h M-S-m" . discover-my-mode)))

(use-package helm-systemd
  :ensure t)

(use-package odf-mode
  :disabled t
  :ensure t)

(use-package edit-server
  :disabled t
  :ensure t
  :init
  (edit-server-start))

(use-package zone
  :disabled t
  :ensure t
  :config (zone-when-idle 120))

(use-package auto-package-update
  :disabled t
  :ensure t
  :config (auto-package-update-maybe))

(use-package dirtree
  :disabled t
  :ensure t
  :config (autoload 'dirtree "dirtree" "Add directory to tree view" t)
  :bind ("C-o" . dirtree-show))

(use-package miniedit
  :defer t
  :ensure t
  :commands minibuffer-edit
  :init (miniedit-install))

;; Enable guide-key-mode
(use-package guide-key
  :disabled t
  :defer t
  :diminish guide-key-mode
  :config
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
  (guide-key-mode 1))

(use-package switch-window
  :ensure t
  :bind (("C-x o" . switch-window)))

(use-package ranger
  :ensure t
  :init
  (setq ranger-parent-depth 2)
  (setq ranger-excluded-extensions '("mkv" "iso" "mp4" "mp3"))
  (setq ranger-max-preview-size 10)
  (setq ranger-override-dired t)
  :bind ("C-c d" . ranger))

(use-package smartscan
  :defer t
  :config (global-smartscan-mode t))

(use-package sx
  :disabled t
  ;; :ensure t
  :config
  (bind-keys :prefix "C-c s"
             :prefix-map my-sx-map
             :prefix-docstring "Global keymap for SX."
             ("q" . sx-tab-all-questions)
             ("i" . sx-inbox)
             ("o" . sx-open-link)
             ("u" . sx-tab-unanswered-my-tags)
             ("a" . sx-ask)
             ("s" . sx-search)))

;; (use-package outline-presentation
;;     ;; :disabled t
;;     :defer t
;;     :ensure t
;;     :init
;;     (add-to-list 'auto-mode-alist '("\\.outline\\'" . outline-mode))
;;     (add-hook 'outline-presentation-mode-hook
;;               (lambda () (text-scale-increase 3))))


(defun set-outline ()
  ;; outline-mode
  (add-to-list 'auto-mode-alist '("\\.outline\\'" . outline-mode))
  (require 'outline-presentation)
  (add-hook 'outline-presentation-mode-hook
            (lambda () (text-scale-increase 3))))

(defun set-realtime-markdown ()
  (load "~/.emacs.d/plugins/websocket.el")
  (package-require 'websocket)
  (load "~/.emacs.d/plugins/emacs-realtime-markdown-viewer/realtime-markdown-viewer.el")
  (package-require 'realtime-markdown-viewer))

;; (defun set-livedown ()
;;   (add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/emacs-livedown"))
;;   (require 'livedown))

(defun set-pair ()
  ;; (package-require 'autopair)
  ;; (autopair-global-mode)
  (use-package smartparens
    :ensure t
    :config
    (require 'smartparens-config)
    (smartparens-global-mode)))

(defun set-uniquify ()
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward))

(defun load-comby-mode ()
  (load "~/.emacs.d/plugins/comby.el/comby.el")
  (require 'comby))

(defun set-buffer-expose ()
  (load "~/.emacs.d/plugins/buffer-expose/buffer-expose.el")
  (require 'buffer-expose)
  (buffer-expose-mode 1)

  (defvar buffer-expose-mode-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "<s-tab>") 'buffer-expose)
      (define-key map (kbd "<C-tab>") 'buffer-expose-no-stars)
      (define-key map (kbd "C-c <C-tab>") 'buffer-expose-current-mode)
      (define-key map (kbd "C-c C-d") 'buffer-expose-dired-buffers)
      (define-key map (kbd "C-c C-*") 'buffer-expose-stars)
      map)
    "Mode map for command `buffer-expose-mode'."))

(defun use-terraform ()
  (use-package terraform-mode
    :ensure t
    :config
    (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)))

(provide 'random-requires)
