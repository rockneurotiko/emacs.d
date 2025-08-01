;; -*- lexical-binding: t;-*-

(use-package treesit
  :straight (:type built-in)
  :setopt
  (treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :setopt
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(defun rock--treesit-fold-trigger ()
  (when (and (treesit-fold-ready-p)
             (treesit-fold-usable-mode-p)
             (<= (count-lines (point-min) (point-max)) 1500))
    (treesit-fold-mode 1)))

(use-package treesit-fold
  :straight (treesit-fold :type git :host github :repo "emacs-tree-sitter/treesit-fold")
  :diminish treesit-fold-mode
  :config
  (setq treesit-fold-line-count-show nil)
  (add-hook 'after-change-major-mode-hook #'rock--treesit-fold-trigger)

  ;; (global-treesit-fold-mode 1)
  :bind (("C-c t o" . treesit-fold-open)
         ("C-c t c" . treesit-fold-close)
         ("C-c t O" . treesit-fold-open-all)
         ("C-c t C" . treesit-fold-close-all)
         ("C-c t t" . treesit-fold-toggle)
         ("C-c t r" . treesit-fold-open-recursively))
  )

(use-package treesit-fold-indicators
  :straight (treesit-fold-indicators :type git :host github :repo "emacs-tree-sitter/treesit-fold")
  :config
  (global-treesit-fold-indicators-mode 1))


(provide 'treesitter-settings)
