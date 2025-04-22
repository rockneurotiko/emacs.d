;; (use-package lua-mode
;;   :ensure t)

;; (use-package rego-mode
;;   :ensure t
;;   :custom
;;   (rego-repl-executable "/usr/bin/opa")
;;   (rego-opa-command "/usr/bin/opa"))

(use-package fish-mode
  :ensure t)

(use-package nushell-mode
  :ensure t
  :straight (:host github :repo "mrkkrp/nushell-mode"))

(provide 'otherlangs-settings)
