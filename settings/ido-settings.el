(require 'ido)
(require 'flx)
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq ido-everywhere 1)
(setq ido-file-extensions-order '(".py" ".org" ".txt" ".cfg" ))
(setq ido-ignore-extensions t)

(provide 'ido-settings)
