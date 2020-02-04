;;------------------------;
;;; Python Programming ;;;
;;------------------------;

;; -----------------------
;; python.el configuration
;; -----------------------

(defun python-hook ()
  (setq python-indent-offset 4)
  (make-local-variable 'auto-indent-assign-indent-level)
  (setq auto-indent-assign-indent-level 4)
  (setq tab-width 4))

;; from python.el
(use-package python
  :ensure t
  :init

  :config
  (setq auto-mode-alist
        (append
         (list '("\\.pyx" . python-mode)
               '("SConstruct" . python-mode))
         auto-mode-alist))
  (define-key python-mode-map (kbd "C-c !") 'python-shell-switch-to-shell)
  (define-key python-mode-map (kbd "C-c |") 'python-shell-send-region)

  (setq interpreter-mode-alist
        (cons '("python" . python-mode)
              interpreter-mode-alist)
        python-mode-hook
        '(lambda () (progn
                      (set-variable 'py-indent-offset 4)
                      (set-variable 'indent-tabs-mode nil))))

  (add-hook 'python-mode-hook 'python-hook))

;; (use-package elpy
;;   :ensure t
;;   :config
;;   (elpy-enable))

;; -----------------------------
;; emacs IPython notebook config
;; -----------------------------
(defun set-ipython ()
  (setq
   python-shell-interpreter "ipython"
   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
   python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
   python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
   python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  ;; IPython notebook
  ;; (use-package ein
  ;;   :ensure t
  ;;   :init
  ;;   ;; use autocompletion, but don't start to autocomplete after a dot
  ;;   (setq ein:complete-on-dot -1)
  ;;   ;; (setq ein:use-auto-complete 1)
  ;;   ;; set python console args
  ;;   (setq ein:console-args "--gui=wx --matplotlib=wx --colors=Linux")
  ;;   ;; timeout settings
  ;;   (setq ein:query-timeout 1000)
  ;;   :config
  ;;   (defun load-ein ()
  ;;     (ein:notebooklist-load)
  ;;     (interactive)
  ;;     (ein:notebooklist-open)))
  )

;; ------------------
;; misc python config
;; ------------------
(defun set-pycomplete ()
  ;; pydoc info
  (use-package pydoc-info
    :ensure t)


  ;; (add-hook 'python-mode-hook 'jedi:setup)
  ;; (add-hook 'python-mode-hook 'jedi:ac-setup)
  ;; (setq jedi:complete-on-dot t)
  ;; ; jedi python completion
  ;; (include-elget-plugin "ctable")   ; required for epc
  ;; (include-elget-plugin "deferred") ; required for epc
  ;; (include-elget-plugin "epc")      ; required for jedi
  ;; (require 'jedi)
  ;; (setq jedi:setup-keys t)
  ;; (autoload 'jedi:setup "jedi" nil t)
  ;; (add-hook 'python-mode-hook 'jedi:setup)
  )


;; Use flycheck!
;; (defun set-flymake ()
;;   ;; pyflakes flymake integration
;;   ;; http://stackoverflow.com/a/1257306/347942
;;   ;; (add-hook 'python-mode-hook
;;   ;; 	  (lambda ()
;;   ;; 	    (unless (eq buffer-file-name nil) (flymake-mode 1))))
;;   (require 'flymake)
;;   (load-library "flymake-cursor")
;;   ;; ;; Script that flymake uses to check code. This script must be
;;   ;; ;; present in the system path.
;;   (setq pycodechecker "pychecker")
;;   (when (load "flymake" t)
;;     (defun flymake-pycodecheck-init ()
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                          'flymake-create-temp-inplace))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;         (list pycodechecker (list local-file))))
;;     (add-to-list 'flymake-allowed-file-name-masks
;;                  '("\\.py\\'" flymake-pycodecheck-init)))
;;   (add-hook 'python-mode-hook 'flymake-mode)
;;   )

;; Set PYTHONPATH, because we don't load .bashrc
(defun set-python-path-from-shell-PYTHONPATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PYTHONPATH'")))
    (setenv "PYTHONPATH" path-from-shell)))

(defun set-virtualenv ()
  ;; VirtualEnv
  (use-package virtualenvwrapper
    :ensure t
    :init
    (setq venv-location "~/Envs")
    :config
    ;; if you want interactive shell support
    (venv-initialize-interactive-shells)
    ;; if you want eshell support
    (venv-initialize-eshell)))


(provide 'python-settings)
