;;-------------------;
;;; Auto-Complete ;;;
;;-------------------;

(use-package orderless
    :ensure t
    :config
    (setq completion-styles '(orderless basic)
          completion-category-defaults nil
          completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
   :ensure t
    :after orderless
    :custom
    (corfu-quit-at-boundary nil)
    (corfu-quit-no-match t)
    (corfu-cycle t)
    (corfu-auto nil)
    :init
    (global-corfu-mode))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)

  ;; Optionally:
  (setq nerd-icons-corfu-mapping
      '((array :style "cod" :icon "symbol_array" :face font-lock-type-face)
        (boolean :style "cod" :icon "symbol_boolean" :face font-lock-builtin-face)
        ;; ...
        (t :style "cod" :icon "code" :face font-lock-warning-face))))


(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
)

(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  ;; (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  (setq text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

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

;; (use-package company
;;   :ensure t
;;   :defer t
;;   :init (global-company-mode)
;;   :config
;;   (progn
;;     ;; Use Company for completion
;;     (bind-key [remap completion-at-point] #'company-complete company-mode-map)

;;     (setq company-tooltip-align-annotations t
;;           ;; Easy navigation to candidates with M-<n>
;;           company-show-numbers t)
;;     (setq company-dabbrev-downcase nil))
;;   :diminish company-mode)

;; (use-package company-quickhelp          ; Documentation popups for Company
;;   :ensure t
;;   :defer t
;;   :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

;; (use-package company-go
;;   :ensure t
;;   :defer t
;;   :init
;;   (with-eval-after-load 'company
;;     (add-to-list 'company-backends 'company-go)))

;; (use-package company-erlang
;;   :ensure t
;;   :defer t
;;   :init (add-hook 'erlang-mode-hook #'company-erlang-init))

(provide 'auto-complete-settings)
