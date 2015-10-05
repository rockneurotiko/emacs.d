;; GO
(require 'go-autocomplete)
(require 'auto-complete-config)

(setenv "GOPATH" "/home/mgarcia/go")

(add-to-list 'load-path "~/go/src/github.com/dougm/goflymake")
(require 'go-flymake)


(defun my-go-mode-hook ()
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)
    (local-set-key (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook 'my-go-mode-hook)



(provide 'go-settings)
