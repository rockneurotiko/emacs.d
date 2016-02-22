(use-package elm-mode
    :ensure t
    :config
    (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
    (package-require 'company)
    (add-to-list 'company-backends 'company-elm)
    (add-hook 'elm-mode-hook #'elm-oracle-setup-ac)
    (package-require 'flycheck)
    (add-hook 'flycheck-mode-hook 'flycheck-elm-setup))

;; (package-require 'elm-mode)

;; (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;; (package-require 'company)
;; (add-to-list 'company-backends 'company-elm)
;; (add-hook 'elm-mode-hook #'elm-oracle-setup-ac)

;; (package-require 'flycheck)
;; ;; (with-eval-after-load 'flycheck
;; ;;     '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))

;; (add-hook 'flycheck-mode-hook 'flycheck-elm-setup)

;; auto-indent-disabled-modes-list

(provide 'elm-settings)
