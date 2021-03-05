;;-------------------;
;;; Auto-Complete ;;;
;;-------------------;

;;; Code:
;; (use-package auto-complete
;;   :ensure t
;;   :init
;;   ;; (setq ac-directory (make-elget-path "auto-complete"))
;;   ;; (add-to-list 'load-path ac-directory)
;;   (require 'auto-complete-config)
;;   :config
;;   (global-auto-complete-mode 1)
;;   (setq-default
;;    ac-sources '(ac-source-yasnippet
;;                 ac-source-abbrev
;;                 ac-source-dictionary
;;                 ac-source-words-in-same-mode-buffers))

;;                                         ; hack to fix ac-sources after pycomplete.el breaks it
;;   (add-hook 'python-mode-hook
;;             '(lambda ()
;;                (setq ac-sources '(ac-source-pycomplete
;;                                   ac-source-yasnippet
;;                                   ac-source-abbrev
;;                                   ac-source-dictionary
;;                                   ac-source-words-in-same-mode-buffers))))
;;   (ac-set-trigger-key "TAB")
;;   (ac-set-trigger-key "<tab>")
;;   (setq ac-auto-start 2)
;;   (setq ac-ignore-case nil))

;; (setq ac-directory (make-elget-path "auto-complete"))
;; (add-to-list 'load-path ac-directory)
;; (require 'auto-complete)

;; (require 'auto-complete-config)
;; (ac-config-default)
;; (global-auto-complete-mode 1)
;; (setq-default ac-sources '(ac-source-yasnippet
;;                            ac-source-abbrev
;;                            ac-source-dictionary
;;                            ac-source-words-in-same-mode-buffers))

;; ; hack to fix ac-sources after pycomplete.el breaks it
;; (add-hook 'python-mode-hook
;;           '(lambda ()
;;              (setq ac-sources '(ac-source-pycomplete
;;                                 ac-source-yasnippet
;;                                 ac-source-abbrev
;;                                 ac-source-dictionary
;;                                 ac-source-words-in-same-mode-buffers))))

;; ;; from http://truongtx.me/2013/01/06/config-yasnippet-and-autocomplete-on-emacs/
;; ; set the trigger key so that it can work together with yasnippet on
;; ; tab key, if the word exists in yasnippet, pressing tab will cause
;; ; yasnippet to activate, otherwise, auto-complete will
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")

;; ;; from http://blog.deadpansincerity.com/2011/05/setting-up-emacs-as-a-javascript-editing-environment-for-fun-and-profit/
;; ; Start auto-completion after 2 characters of a word
;; (setq ac-auto-start 2)
;; ; case sensitivity is important when finding matches
;; (setq ac-ignore-case nil)

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode)
  :config
  (progn
    ;; Use Company for completion
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)

    (setq company-tooltip-align-annotations t
          ;; Easy navigation to candidates with M-<n>
          company-show-numbers t)
    (setq company-dabbrev-downcase nil))
  :diminish company-mode)

(use-package company-quickhelp          ; Documentation popups for Company
  :ensure t
  :defer t
  :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

(use-package company-go
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-go)))

(use-package company-erlang
  :ensure t
  :defer t
  :init (add-hook 'erlang-mode-hook #'company-erlang-init))

(provide 'auto-complete-settings)
