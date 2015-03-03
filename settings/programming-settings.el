;;--PROLOG
(require 'prolog-settings

         )
;;--JAVASCRIPT && WEB
(require 'js-settings)
(load-web-mode)
;; (load-tern)
;; (load-angular)


;;--JULIA
(require 'julia-settings)


;;--GO
(require 'go-settings)


;;--SCALA
(require 'scala-settings)


;;--PYTHON
(require 'python-settings)
(set-ipython)
(set-pycomplete)
(set-flymake)
(set-virtualenv)


;;--OCAML
(require 'ocaml-settings)


;;--HASKELL
(require 'haskell-settings)


;;--MARKDOWN
(require 'markdown-settings)
(provide 'programming-settings)
