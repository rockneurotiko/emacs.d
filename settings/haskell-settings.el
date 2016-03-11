;;; bodil-haskell.el --- FIRE ALL MONAD TRANSFORMERS

;; Use Unicode arrows in place of ugly ASCII arrows
(defun setup-haskell-arrows (mode mode-map)
  (font-lock-replace-symbol mode "\\(->\\)" "→")
  (font-lock-replace-symbol mode "\\(<-\\)" "←")
  (font-lock-replace-symbol mode "\\(=>\\)" "⇒")

  (define-key mode-map (kbd "→") (lambda () (interactive) (insert "->")))
  (define-key mode-map (kbd "←") (lambda () (interactive) (insert "<-")))
  (define-key mode-map (kbd "⇒") (lambda () (interactive) (insert "=>"))))

(use-package haskell-mode
  :ensure t
  :config
  (custom-set-variables
   '(haskell-mode-hook
     '(;; turn-on-haskell-indentation
       turn-on-haskell-doc
       ;; structured-haskell-mode
       )))
  (setup-haskell-arrows 'haskell-mode haskell-mode-map)
  ;; Variables
  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t)
   ;; '(haskell-process-type 'cabal-repl)    ; CABAL
   '(haskell-process-type 'stack-ghci))
  (define-key haskell-mode-map (kbd "C-x C-d") nil)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
  (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-s") (lambda () (interactive) (haskell-process-do-type t)))
  (define-key haskell-mode-map (kbd "C-c M-.") nil)
  (define-key haskell-mode-map (kbd "C-c TAB") 'ghc-show-info-popup)
  (define-key haskell-mode-map (kbd "C-c C-i") 'ghc-show-info-popup)
  (define-key haskell-mode-map (kbd "C-c C-S-i") 'ghc-show-info)
  (define-key haskell-mode-map (kbd "C-c C-d") nil)
  (define-key haskell-mode-map (kbd "C-c C-,") 'haskell-mode-run-test-suite)
  (define-key haskell-mode-map (kbd "C-c f") 'haskell-mode-stylish-buffer))


(use-package ghc
  :ensure t
  :config
  (autoload 'ghc-init "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
  (package-require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (add-to-list 'company-backends 'company-ghc)
  (custom-set-variables '(company-ghc-show-info t)))

(use-package hi2
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'turn-on-hi2))

(use-package hindent
  :ensure t
  :config
  (add-hook 'haskell-mode-hook #'hindent-mode))

(use-package shm
  :ensure t)



;; (package-require 'haskell-mode)
;; (package-require 'ghc)
;; (package-require 'hi2)
;; (package-require 'hindent)
;; (package-require 'shm)

;; ;; Setup haskell-mode hooks
;; (eval-after-load "haskell-mode"
;;   '(custom-set-variables
;;     '(haskell-mode-hook
;;       '(;; turn-on-haskell-indentation
;;         turn-on-haskell-doc
;;         ;; structured-haskell-mode
;;         ))))

;; (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
;;     (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
;;     (add-to-list 'exec-path my-cabal-path))

;; (autoload 'ghc-init "ghc" nil t)
;; (autoload 'ghc-debug "ghc" nil t)
;; (add-hook 'haskell-mode-hook (lambda () (ghc-init)))


;; (add-hook 'haskell-mode-hook 'turn-on-hi2)
;; (add-hook 'haskell-mode-hook #'hindent-mode)


;; (eval-after-load "haskell-mode"
;;   '(setup-haskell-arrows 'haskell-mode haskell-mode-map))

;; ;; Variables
;; (custom-set-variables
;;  '(haskell-process-suggest-remove-import-lines t)
;;  '(haskell-process-auto-import-loaded-modules t)
;;  '(haskell-process-log t)
;;  ;; '(haskell-process-type 'cabal-repl)    ; CABAL
;;  '(haskell-process-type 'stack-ghci))

;; Setup haskell-interactive-mode
;; (eval-after-load "haskell-mode"
;;   '(progn
;;     (define-key haskell-mode-map (kbd "C-x C-d") nil)
;;     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
;;     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
;;     (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
;;     (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
;;     (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
;;     (define-key haskell-mode-map (kbd "C-c C-s") (lambda () (interactive) (haskell-process-do-type t)))
;;     (define-key haskell-mode-map (kbd "C-c M-.") nil)
;;     (define-key haskell-mode-map (kbd "C-c TAB") 'ghc-show-info-popup)
;;     (define-key haskell-mode-map (kbd "C-c C-i") 'ghc-show-info-popup)
;;     (define-key haskell-mode-map (kbd "C-c C-S-i") 'ghc-show-info)
;;     (define-key haskell-mode-map (kbd "C-c C-d") nil)
;;     (define-key haskell-mode-map (kbd "C-c C-,") 'haskell-mode-run-test-suite)
;;     (define-key haskell-mode-map (kbd "C-c f") 'haskell-mode-stylish-buffer)))

(eval-after-load 'haskell-cabal
  '(progn
     (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
     (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
     (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

;; Put ghc-show-info in a popup
(defun ghc-show-info-popup ()
  (package-require 'popup)
  (interactive)
  (popup-tip (ghc-get-info (ghc-things-at-point))
             :around t :scroll-bar t))

;; Use standard keybinding for inferior-haskell-find-definition
;; (define-key haskell-mode-map (kbd "M-.")
;;     (lambda () (interactive)
;;       (inferior-haskell-find-definition (haskell-ident-at-point))))

;; Run test suite
(defun haskell-mode-run-test-suite ()
  (interactive)
  (require 'compile)
  (compile (concat "cd " (projectile-project-root) "; cabal test")))

;; Flycheck addons
(use-package flycheck-haskell
  :ensure t
  :config (add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
;; (package-require 'flycheck-haskell)
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))


;;; Idris (for want of a better place to put it)
(use-package idris-mode
  :disabled t
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.idr$" . idris-mode))
  (setup-haskell-arrows 'idris-mode idris-mode-map))
;; (package-require 'idris-mode)
;; (require 'idris-mode)
;; (add-to-list 'auto-mode-alist '("\\.idr$" . idris-mode))
;; (setup-haskell-arrows 'idris-mode idris-mode-map)

(provide 'haskell-settings)
;;; haskell-settings.el ends here
