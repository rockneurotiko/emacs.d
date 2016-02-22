(use-package flx
    :ensure t)

(use-package ido
    :disabled t
    :ensure t
    :init
    (setq ido-enable-flex-matching t)
    (setq ido-use-faces nil)
    (setq ido-everywhere 1)
    (setq ido-file-extensions-order '(".py" ".org" ".txt" ".cfg" ))
    (setq ido-ignore-extensions t)
    :config
    (ido-mode 1)
    (ido-everywhere 1))

(use-package flx-ido
    :disabled t
    :ensure t
    :config
    (flx-ido-mode 1))

;; (require 'ido)
;; (require 'flx)
;; (require 'flx-ido)
;; (ido-mode 1)
;; (ido-everywhere 1)
;; (flx-ido-mode 1)
;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; (setq ido-everywhere 1)
;; (setq ido-file-extensions-order '(".py" ".org" ".txt" ".cfg" ))
;; (setq ido-ignore-extensions t)

(provide 'ido-settings)
