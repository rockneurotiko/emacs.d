;; GO
(use-package go-autocomplete
    :ensure t
    :config
    (require 'auto-complete-config))

;; (require 'go-autocomplete)
;; (require 'auto-complete-config)

(setenv "GOPATH" (expand-file-name "~/go"))

;; If with warning print?
(when (file-exists-p (expand-file-name "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el"))
    (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el"))

;; If with warning print?
(when (file-exists-p (expand-file-name "$GOPATH/src/github.com/dougm/goflymake"))
    (add-to-list 'load-path "$GOPATH/src/github.com/dougm/goflymake")
    (require 'go-flymake))


(defun my-go-mode-hook ()
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)
    (if (not (string-match "go" compile-command))
            (set (make-local-variable 'compile-command)
                 "go build -v && go test -v && go vet"))

    (setq tab-width 2 indent-tabs-mode nil)
    (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun my-go-mode-hook ()
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)
    (local-set-key (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook 'my-go-mode-hook)


(provide 'go-settings)
