;;----------------------;
;;; Javascript & Web ;;;
;;----------------------;

(defun load-tern ()
  (use-package tern
    :ensure t
    :diminish tern-mode
    :config
    (defun ternhook ()
      (tern-mode t)
      ;; (auto-complete-mode)
      )
    (add-hook 'js2-mode-hook 'ternhook)
    (add-hook 'web-mode-hook 'ternhook)
    ;; (require 'tern-auto-complete)
    ;; (tern-ac-setup)
    )

  (defun delete-tern-process ()
    (interactive)
    (delete-process "Tern")))

;; Replace with tsx?
(defun use-js2 ()
  (use-package js2-mode
    :ensure t
    :init
    (setq js-indent-level 2)
    (setq js2-indent-level 2)
    (setq-default js2-basic-offset 2)
    (setq ac-js2-evaluate-calls t)
    (setq js2-highlight-level 3)
    :config
    (add-hook 'js2-mode-hook 'ac-js2-mode)
    (add-hook 'js2-mode-hook 'jasminejs-mode)
    (use-package js2-refactor
      :ensure t
      :config
      (add-hook 'js2-mode-hook #'js2-refactor-mode)
      (js2r-add-keybindings-with-prefix "C-c C-m"))

    (js2-imenu-extras-mode)
    (apply #'derived-mode-p '(org-mode web-mode))

    (add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . js2-jsx-mode))

    (add-hook 'js2-post-parse-callbacks
              (lambda ()
                (when (> (buffer-size) 0)
                  (let ((btext (replace-regexp-in-string
                                ": *true" " "
                                (replace-regexp-in-string "[\n\t ]+" " " (buffer-substring-no-properties 1 (buffer-size)) t t))))
                    (mapc (apply-partially 'add-to-list 'js2-additional-externs)
                          (split-string
                           (if (string-match "/\\* *global *\\(.*?\\) *\\*/" btext) (match-string-no-properties 1 btext) "")
                           " *, *" t))
                    )))))

  (use-package json-mode
    :ensure t
    :config
    (add-to-list 'auto-mode-alist '("\\.json\\'\\|\\.jshintrc\\'" . json-mode)))

  (use-package jasminejs-mode
    :ensure t
    :diminish jasminejs-mode
    :config
    (add-hook 'jasminejs-mode-hook (lambda () (jasminejs-add-snippets-to-yas-snippet-dirs))))

  (use-package js2-refactor
    :ensure t
    :diminish js2-refactor-mode)

  (add-to-list 'auto-mode-alist
               '("\\.p?html\\(\\.[a-z]\\{2\\}\\)?\\'" . html-mode)))

(defun load-web-mode ()
  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 4)
    (set-face-attribute 'web-mode-css-at-rule-face nil :foreground "Pink3")
    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-enable-css-colorization t)
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-enable-current-column-highlight t)
    (setq web-mode-enable-auto-expanding t))

  (use-package web-mode
    :ensure t
    :init
    (setq web-mode-content-types-alist
          '(("jsx" . "\\.js[x]?\\'")))
    :config
    (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
    (add-hook 'web-mode-hook  'my-web-mode-hook))

  ;; (package-require 'web-mode)
  ;; (load "~/.emacs.d/plugins/web-mode/web-mode.el")

  ;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))

  ;; (setq web-mode-content-types-alist
  ;;       '(("jsx" . "\\.js[x]?\\'")))
  )

(use-package emmet-mode
  :ensure t
  :config
  (defun emmet-hook()
    (emmet-mode)
    (local-set-key (kbd "M-TAB") 'emmet-expand-line))
  ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-hook)
  ;; enable Emmet's css abbreviation.
  (add-hook 'css-mode-hook  'emmet-hook))

(use-package nodejs-repl
  :ensure t
  :config
  (defun my-jscallback ()
    (local-set-key (kbd "C-c C-e") 'nodejs-repl-send-buffer))

  (add-hook 'js-mode-hook 'my-jscallback))

(provide 'js-settings)
