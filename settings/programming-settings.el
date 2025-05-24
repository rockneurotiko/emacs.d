;; -*- lexical-binding: t; -*-

;;; package -- summary

;;; Commentary:

;;--JAVASCRIPT && WEB
(require 'js-settings)
(load-web-mode)
(use-js2)

;;--GO
(require 'go-settings)


;;--SCALA
;; (require 'scala-settings)

;;-- ELISP
(require 'elisp-settings)

;;--PYTHON
(require 'python-settings)
;; (set-ipython)
;; (set-pycomplete)
;; (set-flymake)
;; (set-virtualenv)

;;--TypeScript
;; (require 'tss-settings)

;;--HASKELL
;; (require 'haskell-settings)

;;--MARKDOWN
(require 'markdown-settings)

;;--RUST
(require 'rust-settings)

;;--CLOJURE
;; (require 'clojure-settings)

;; ELIXIR
(require 'elixir-settings)

;; GRAPHQL
(require 'graphql-settings)

;; LSP!!
;; (require 'lsp-settings)
(require 'eglot-settings)
;; (require 'mcp-settings)
(require 'llm-settings)

(require 'treesitter-settings)

;; Other langs
(require 'otherlangs-settings)

(provide 'programming-settings)
;;; programming-settings.el ends here
