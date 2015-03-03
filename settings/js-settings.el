;----------------------;
;;; Javascript & Web ;;;
;----------------------;

(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js-indent-level 4)
(setq js2-indent-level 4)
(setq-default js2-basic-offset 4)
(setq ac-js2-evaluate-calls t)
(setq js2-highlight-level 3)

;; web dev
(add-to-list 'auto-mode-alist '("\\.php[345]?\\'\\|\\.inc\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'\\|\\.jshintrc\\'" . json-mode))
;;(add-to-list 'auto-mode-alist '("\\.json\\'\\|\\.jshintrc\\'" . json-mode))
(add-to-list 'auto-mode-alist
             '("\\.p?html\\(\\.[a-z]\\{2\\}\\)?\\'" . html-mode))

(defun load-tern ()
    (load "~/.emacs.d/plugins/tern.el")
    (load "~/.emacs.d/plugins/tern-auto-complete.el")

    (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
    (eval-after-load 'tern
        '(progn
             (require 'tern-auto-complete)
             (tern-ac-setup)))
    (defun delete-tern-process ()
      (interactive)
      (delete-process "Tern"))
    )

(defun load-angular ()
    (require 'angular-snippets)
    (eval-after-load "sgml-mode"
        '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))
    )

(defun load-web-mode ()
    (load "~/.emacs.d/plugins/web-mode/web-mode.el")
    (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
    )

(provide 'js-settings)
