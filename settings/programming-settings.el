;;--PROLOG
(require 'prolog-settings)

;;--JAVASCRIPT && WEB
(require 'js-settings)
(load-web-mode)
;; (load-tern)
;; (load-angular)


;;--JULIA
(require 'julia-settings)



;; ;; Ignoring electric indentation
;; (defun electric-indent-ignore-pony (char)
;;     "Ignore electric indentation for python-mode"
;;     (if (equal major-mode 'ponylang-mode)
;;             'no-indent
;;         nil))
;; (add-hook 'electric-indent-functions 'electric-indent-ignore-pony)

;; ;; Enter key executes newline-and-indent
;; (defun set-newline-and-indent ()
;;     "Map the return key with `newline-and-indent'"
;;     (local-set-key (kbd "RET") 'newline-and-indent))
;; (add-hook 'ponylang-mode-hook 'set-newline-and-indent)

;;--PONY
(require 'ponylang-mode)
(add-hook 'ponylang-mode-hook
          (lambda ()
              (setq auto-indent-newline-function 'newline-and-indent)
              (setq tab-width 2)
              (auto-indent-mode -1)
              (electric-indent-local-mode -1)
              ))

;;--GO
(require 'go-settings)


;;--SCALA
(require 'scala-settings)


;;--PYTHON
(require 'python-settings)
(set-ipython)
;;(set-pycomplete)
(set-flymake)
(set-virtualenv)

;;--TypeScript
(require 'tss-settings)

;;--OCAML
(require 'ocaml-settings)


;;--HASKELL
(require 'haskell-settings)


;;--MARKDOWN
(require 'markdown-settings)
(provide 'programming-settings)
