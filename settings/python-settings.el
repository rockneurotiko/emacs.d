;------------------------;
;;; Python Programming ;;;
;------------------------;

;; -----------------------
;; python.el configuration
;; -----------------------

; from python.el
(require 'python)

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

    ;; use autocompletion, but don't start to autocomplete after a dot
    (setq ein:complete-on-dot -1)
    (setq ein:use-auto-complete 1)
                                        ; set python console args
    (setq ein:console-args "--gui=wx --matplotlib=wx --colors=Linux")
                                        ; timeout settings
    (setq ein:query-timeout 1000)
                                        ; IPython notebook
    (require 'ein)
                                        ; shortcut function to load notebooklist
    (defun load-ein ()
        (ein:notebooklist-load)
        (interactive)
        (ein:notebooklist-open))
    )


;; ------------------
;; misc python config
;; ------------------
(defun set-pycomplete ()
    ;; pydoc info
    (require 'pydoc-info)
    ;; ; jedi python completion
    ;; (include-elget-plugin "ctable")   ; required for epc
    ;; (include-elget-plugin "deferred") ; required for epc
    ;; (include-elget-plugin "epc")      ; required for jedi
    ;; (require 'jedi)
    ;; (setq jedi:setup-keys t)
    ;; (autoload 'jedi:setup "jedi" nil t)
    ;; (add-hook 'python-mode-hook 'jedi:setup)
    )



(defun set-flymake ()
    ;; pyflakes flymake integration
    ;; http://stackoverflow.com/a/1257306/347942
    ;; (add-hook 'python-mode-hook
    ;; 	  (lambda ()
    ;; 	    (unless (eq buffer-file-name nil) (flymake-mode 1))))
    (require 'flymake)
    (load-library "flymake-cursor")
    ;; ;; Script that flymake uses to check code. This script must be
    ;; ;; present in the system path.
    (setq pycodechecker "pychecker")

    (when (load "flymake" t)
        (defun flymake-pycodecheck-init ()
            (let* ((temp-file (flymake-init-create-temp-buffer-copy
                               'flymake-create-temp-inplace))
                   (local-file (file-relative-name
                                temp-file
                                (file-name-directory buffer-file-name))))
                (list pycodechecker (list local-file))))
        (add-to-list 'flymake-allowed-file-name-masks
                     '("\\.py\\'" flymake-pycodecheck-init)))
    (add-hook 'python-mode-hook 'flymake-mode)
    )


; Set PYTHONPATH, because we don't load .bashrc
(defun set-python-path-from-shell-PYTHONPATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PYTHONPATH'")))
    (setenv "PYTHONPATH" path-from-shell)))

(setq auto-mode-alist
      (append
       (list '("\\.pyx" . python-mode)
             '("SConstruct" . python-mode))
       auto-mode-alist))

(defun set-virtualenv ()
    ;; VirtualEnv
    (require 'virtualenvwrapper)
    (venv-initialize-interactive-shells) ;; if you want interactive shell support
    (venv-initialize-eshell) ;; if you want eshell support
    (setq venv-location "~/Envs")
    )

; keybindings
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c !") 'python-shell-switch-to-shell))
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c |") 'python-shell-send-region))

(provide 'python-settings)
