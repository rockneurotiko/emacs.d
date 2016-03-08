;;; package -- summary

;;; Commentary:

;;; Code:
;;--PROLOG
;; (require 'prolog-settings)

;; Flycheck
(require 'flycheck-settings)

;;--JAVASCRIPT && WEB
(require 'js-settings)
(load-web-mode)
(use-js2)
(load-tern)
(js-flycheck)
(set-emmet)
;; (load-angular)


;;--JULIA
;; (require 'julia-settings)



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

;;--GO
(require 'go-settings)


;;--SCALA
(require 'scala-settings)

;;--JAVA
(require 'java-settings)


;;-- ELISP
(require 'elisp-settings)

;;--PONY
;; (require 'pony-settings)

;;--PYTHON
(require 'python-settings)
(set-ipython)
(set-pycomplete)
;; (set-flymake)
(set-virtualenv)
(elpy-enable)

;;--TypeScript
;; (require 'tss-settings)

;;--OCAML
;; (require 'ocaml-settings)


;;--HASKELL
(require 'haskell-settings)


;;--MARKDOWN
(require 'markdown-settings)


;;--RUST
;; (require 'rust-settings)

;;--ELM
(require 'elm-settings)


;; Other langs
(require 'otherlangs-settings)

(provide 'programming-settings)
;;; programming-settings.el ends here
