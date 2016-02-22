(defun set-turtle ()
    (package-require 'ttl-mode)
    (autoload 'ttl-mode "ttl-mode" "Major mode for OWL or Turtle files" t)
    (add-hook 'ttl-mode-hook    ; Turn on font lock when in ttl mode
              'turn-on-font-lock)
    (setq auto-mode-alist
          (append
           (list
            '("\\.n3" . ttl-mode)
            '("\\.ttl" . ttl-mode))
           auto-mode-alist))
)

(provide 'websemantica-settings)
