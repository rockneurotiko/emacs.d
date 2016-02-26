;----------------------;
;;; Javascript & Web ;;;
;----------------------;

(defun load-tern ()
    (use-package tern
        :ensure t
        :diminish tern-mode
        :config
        (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
        (add-hook 'web-mode-hook (lambda () (tern-mode t)))
        ;; (add-hook 'js2-mode-hook 'tern-mode)
        ;; (add-hook 'web-mode-hook 'tern-mode)
        (require 'tern-auto-complete)
        (tern-ac-setup)
        )

    ;; (use-package tern-auto-complete
    ;;     :ensure t
    ;;     :config
    ;;     (tern-ac-setup))

    (defun delete-tern-process ()
        (interactive)
        (delete-process "Tern"))

    ;; (package-require 'tern)
    ;; (package-require 'tern-auto-complete)
    ;; (add-to-list 'load-path "~/.emacs.d/plugins/tern/emacs/")
    ;; (autoload 'tern-mode "tern.el" nil t)
    ;; (load "~/.emacs.d/plugins/tern.el")
    ;; (load "~/.emacs.d/plugins/tern-auto-complete.el")
    ;; (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
    ;; (add-hook 'web-mode-hook (lambda () (tern-mode t)))
    ;; (eval-after-load 'tern
    ;;     '(progn
    ;;          (package-require 'tern-auto-complete)
    ;;          (tern-ac-setup)))
    )

(defun load-angular ()
    (use-package angular-snippets
        :ensure t
        :config
        (define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))
    ;; (package-require 'angular-snippets)
    ;; (eval-after-load "sgml-mode"
    ;;     '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))
    )

(defun js-flycheck ()
    (use-package flycheck
        :ensure t
        :diminish flycheck-mode
        :config
        (add-hook 'js-mode-hook 'flycheck-mode)
        (add-hook 'web-mode-hook 'flycheck-mode)
        (flycheck-add-mode 'javascript-jshint 'web-mode)
        (flycheck-add-mode 'html-tidy 'web-mode))

    ;; (package-require 'flycheck)
    ;; (add-hook 'js-mode-hook
    ;;           (lambda () (flycheck-mode t)))
    ;; (package-require 'flycheck)
    )

(defun use-js2 ()
    (use-package js2-mode
        :ensure t
        :init
        (setq js-indent-level 4)
        (setq js2-indent-level 4)
        (setq-default js2-basic-offset 4)
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

    (use-package php-mode
        :ensure t
        :config
        (add-to-list 'auto-mode-alist '("\\.php[345]?\\'\\|\\.inc\\'" . php-mode)))

    (use-package json-mode
        :ensure t
        :config
        (add-to-list 'auto-mode-alist '("\\.json\\'\\|\\.jshintrc\\'" . json-mode)))

    (use-package jasminejs-mode
        :ensure t
        :config
        (add-hook 'jasminejs-mode-hook (lambda () (jasminejs-add-snippets-to-yas-snippet-dirs))))

    (use-package js2-refactor
        :ensure t)

    (add-to-list 'auto-mode-alist
                 '("\\.p?html\\(\\.[a-z]\\{2\\}\\)?\\'" . html-mode))

    ;; (package-require 'js2-mode)
    ;; (package-require 'php-mode)
    ;; (package-require 'json-mode)
    ;; (package-require 'jasminejs-mode)
    ;; (package-require 'js2-refactor)

    ;; (add-hook 'js-mode-hook 'js2-minor-mode)

    ;; (add-hook 'js2-mode-hook 'ac-js2-mode)
    ;; (add-hook 'js2-mode-hook 'jasminejs-mode)
    ;; (add-hook 'js2-mode-hook #'js2-refactor-mode)
    ;; (js2r-add-keybindings-with-prefix "C-c C-m")

    ;; (add-hook 'js2-mode-hook 'skewer-mode)
    ;; (add-hook 'css-mode-hook 'skewer-css-mode)
    ;; (add-hook 'html-mode-hook 'skewer-html-mode)

    ;; (js2-imenu-extras-mode)
    ;; (setq js-indent-level 4)
    ;; (setq js2-indent-level 4)
    ;; (setq-default js2-basic-offset 4)
    ;; (setq ac-js2-evaluate-calls t)
    ;; (setq js2-highlight-level 3)

    ;; (apply #'derived-mode-p '(org-mode web-mode))

    ;; (add-hook 'jasminejs-mode-hook (lambda () (jasminejs-add-snippets-to-yas-snippet-dirs)))

    ;; (add-hook 'js2-post-parse-callbacks
    ;;           (lambda ()
    ;;               (when (> (buffer-size) 0)
    ;;                   (let ((btext (replace-regexp-in-string
    ;;                                 ": *true" " "
    ;;                                 (replace-regexp-in-string "[\n\t ]+" " " (buffer-substring-no-properties 1 (buffer-size)) t t))))
    ;;                       (mapc (apply-partially 'add-to-list 'js2-additional-externs)
    ;;                             (split-string
    ;;                              (if (string-match "/\\* *global *\\(.*?\\) *\\*/" btext) (match-string-no-properties 1 btext) "")
    ;;                              " *, *" t))
    ;;                       ))))

    ;; web dev
    ;; (add-to-list 'auto-mode-alist '("\\.php[345]?\\'\\|\\.inc\\'" . php-mode))
    ;; (add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . js2-jsx-mode))
    ;; (add-to-list 'auto-mode-alist '("\\.json\\'\\|\\.jshintrc\\'" . json-mode))
    ;; (add-to-list 'auto-mode-alist
    ;;              '("\\.p?html\\(\\.[a-z]\\{2\\}\\)?\\'" . html-mode))
    )

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

(defun set-emmet ()
    (use-package emmet-mode
        :ensure t
        :config
        (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
        (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
        :bind ("M-TAB" . emmet-expand-line))
    ;; (require 'web-mode)
    ;; (package-require 'emmet-mode)
    ;; (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
    ;; (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
    ;; (define-key web-mode-map (kbd "M-TAB") 'emmet-expand-line)
    )

(provide 'js-settings)
