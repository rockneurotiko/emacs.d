(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook 'subword-mode)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

(use-package paredit
  :ensure t
  :config
  (add-hook 'clojure-mode-hook 'enable-paredit-mode))

(use-package clojure-mode-extra-font-locking
  :ensure t
  :config
  (require 'clojure-mode-extra-font-locking)
  (add-hook 'clojure-mode-hook
            (lambda ()
              (setq inferior-lisp-program "lein repl")
              (font-lock-add-keywords
               nil
               '(("(\\(facts?\\)"
                  (1 font-lock-keyword-face))
                 ("(\\(background?\\)"
                  (1 font-lock-keyword-face))))
              (define-clojure-indent (fact 1))
              (define-clojure-indent (facts 1)))))

;; key bindings
;; these help me out with the way I usually develop web apps
(defun cider-start-http-server ()
  (interactive)
  (cider-load-current-buffer)
  (let ((ns (cider-current-ns)))
    (cider-repl-set-ns ns)
    (cider-interactive-eval (format "(println '(def server (%s/start))) (println 'server)" ns))
    (cider-interactive-eval (format "(def server (%s/start)) (println server)" ns))))


(defun cider-refresh ()
  (interactive)
  (cider-interactive-eval (format "(user/reset)")))

(defun cider-user-ns ()
  (interactive)
  (cider-repl-set-ns "user"))


(use-package cider
  :ensure t
  :init
  ;; go right to the REPL buffer when it's finished connecting
  (setq cider-repl-pop-to-buffer-on-connect t)

  ;; When there's a cider error, show its buffer and switch to it
  (setq cider-show-error-buffer t)
  (setq cider-auto-select-error-buffer t)

  ;; Where to store the cider history.
  (setq cider-repl-history-file "~/.emacs.d/cider-history")

  ;; Wrap when navigating history.
  (setq cider-repl-wrap-history t)

  :config
  ;; provides minibuffer documentation for the code you're typing into the repl
  (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

  ;; enable paredit in your REPL
  (add-hook 'cider-repl-mode-hook 'paredit-mode)

  ;; Use clojure mode for other extensions
  :mode (("\\.edn$" . clojure-mode)
         ("\\.boot$" . clojure-mode)
         ("\\.cljs.*$" . clojure-mode)
         ("lein-env" . enh-ruby-mode))
  :bind (:map clojure-mode-map
              ("C-c C-v" . cider-start-http-server)
              ("C-M-r" . cider-refresh)
              ("C-c u" . cider-user-ns)
              :map cider-mode-map
              ("C-c u" . cider-user-ns)))


(provide 'clojure-settings)
