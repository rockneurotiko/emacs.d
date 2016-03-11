(use-package elm-mode
  :ensure t
  :config
  (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
  (package-require 'company)
  (add-to-list 'company-backends 'company-elm)
  (add-hook 'elm-mode-hook #'elm-oracle-setup-ac))

(use-package flycheck-elm
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-elm-setup))

;; (package-require 'elm-mode)

;; (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;; (package-require 'company)
;; (add-to-list 'company-backends 'company-elm)
;; (add-hook 'elm-mode-hook #'elm-oracle-setup-ac)

;; auto-indent-disabled-modes-list

(provide 'elm-settings)
;;; elm-settings.el ends here
