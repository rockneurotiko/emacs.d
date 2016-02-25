;; (package-require 'flycheck)

(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; (require 'flymake-rust)
;; (add-hook 'rust-mode-hook 'flymake-rust-load)

(use-package rust-mode
  :ensure t
  :init
  (setq racer-cmd "/usr/bin/racer")
  (setq racer-rust-src-path "/usr/src/rust/src/")
  :config
  (add-hook 'rust-mode-hook
            '(lambda ()
               (racer-activate)
               (racer-turn-on-eldoc)
               (local-set-key (kbd "M-.") #'racer-find-definition)
               (local-set-key (kbd "TAB") #'racer-complete-or-indent))))



(provide 'rust-settings)
