;; (package-require 'flycheck)

;;(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; (require 'flymake-rust)
;; (add-hook 'rust-mode-hook 'flymake-rust-load)

(use-package rust-mode
  :ensure t
  :init
  (setq rust-format-on-save t)
  (setq rust-mode-treesitter-derive t)
  (add-hook 'rust-mode-hook #'lsp)

  ;; (add-hook 'rust-mode-hook
  ;;           '(lambda ()
  ;;              (racer-activate)
  ;;              (racer-turn-on-eldoc)
  ;;              (local-set-key (kbd "M-.") #'racer-find-definition)
  ;;              (local-set-key (kbd "TAB") #'racer-complete-or-indent)))
  )

;; (use-package racer
;;   :ensure t
;;   :init
;;   (setq racer-cmd "~/.cargo/bin/racer")
;;   (setq racer-rust-src-path "/usr/src/rust/src/")
;;   :config
;;   (add-hook 'rust-mode-hook #'racer-mode)
;;   (add-hook 'racer-mode-hook #'eldoc-mode)
;;   (add-hook 'racer-mode-hook #'company-mode)

;;   (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
;;   (setq company-tooltip-align-annotations t))

(provide 'rust-settings)
