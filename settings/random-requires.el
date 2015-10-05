(defun set-undo ()
    ;; Undo properties
    (require 'undo-tree)
    (global-undo-tree-mode 1)
    (defalias 'redo 'undo-tree-redo)
    (global-set-key (kbd "C-z") 'undo)
    (global-set-key (kbd "C-S-z") 'redo)
    )

(defun set-outline ()
    ;; outline-mode
    (add-to-list 'auto-mode-alist '("\\.outline\\'" . outline-mode))
    (require 'outline-presentation)
    (add-hook 'outline-presentation-mode-hook
              (lambda () (text-scale-increase 3)))
    )

(defun set-autoindent ()
    (require 'auto-indent-mode)
    (auto-indent-global-mode)
    (setq tab-width 4)
    )

(defun set-git-gutter-fringe+ ()
    (require 'git-gutter-fringe+)
    (global-git-gutter+-mode 1)
    (git-gutter-fr+-minimal)
    (setq-default indicate-buffer-boundaries 'left)
    (setq-default indicate-empty-lines +1)
    )

(defun set-uml-plantuml ()
    (require 'plantuml-mode)
    ;; active Org-babel languages
    (org-babel-do-load-languages
     'org-babel-load-languages
     '(;; other Babel languages
       (plantuml . t)))
    (setq org-plantuml-jar-path
          (expand-file-name "/opt/plantuml/plantuml.jar"))
    )

(defun set-libreoffice ()
    (require 'odf-mode)
    )

(defun set-realtime-markdown ()
    (load "~/.emacs.d/plugins/websocket.el")
    (require 'websocket)
    (load "~/.emacs.d/plugins/emacs-realtime-markdown-viewer/realtime-markdown-viewer.el")
    (require 'realtime-markdown-viewer)
    )

(defun set-livedown ()
    (add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/emacs-livedown"))
    (require 'livedown)

    )

(defun set-scroll ()
    (require 'smooth-scroll)
    (require 'smooth-scrolling)
    )

(defun set-auto-complete ()
    ;; Autocompletado
    (require 'auto-complete)
    (global-auto-complete-mode t)
    )

(defun set-indent-guide ()
    (require 'indent-guide)
    (indent-guide-global-mode)
    ;;(set-face-background 'indent-guide-face "dimgray")
    (setq indent-guide-recursive t)
    )

(defun set-pair ()
    ;; (require 'autopair)
    ;; (autopair-global-mode)
    (require 'smartparens-config)
    (smartparens-global-mode)
    )

(defun set-multiple-cursors ()
    (require 'multiple-cursors)
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
    )

(defun set-zone ()
    (require 'zone)
    (zone-when-idle 120)
    )

(defun set-auto-update ()
    ;; Auto package update
    (require 'auto-package-update)
    (auto-package-update-maybe)
    )

(defun set-uniquify ()
    (require 'uniquify)
    (setq uniquify-buffer-name-style 'forward)
    )

(defun set-mochi ()
    (require 'mochi-mode)
    (setq-default indent-tabs-mode nil)
    )

(defun set-dirtree ()
    (require 'dirtree)
    (autoload 'dirtree "dirtree" "Add directory to tree view" t)
    (global-set-key "\C-o" 'dirtree-show))

(provide 'random-requires)
