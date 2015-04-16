(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO(t)" "PENDING(p)" "MEETING(m)" "|" "DONE(d)" "CANCELED(c)")))

;; Stop org-mode from highjacking shift-cursor keys
(setq org-replace-disputed-keys t)

(require 'org-agenda)
(setq org-agenda-span 14)

(defun my-org-autodone (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
        (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'my-org-autodone)

(setq org-refile-targets '((nil :level . 1)
                           (org-agenda-files :level . 1)))
(setq-default org-src-fontify-natively t)



(defun set-org-babel ()

    (global-set-key "\C-cu" 'my/org-babel-untangle)

    (defun my/org-babel-untangle (path)
        (interactive "fFile to include: ")
        (message "Untangling '%s'..." path)
        (save-current-buffer
            (let ((lang (save-current-buffer
                            (set-buffer (find-file-noselect path))
                            (my/mode->language major-mode))))
                (insert (format "\n** %s\n\n#+BEGIN_SRC %s :tangle %s\n"
                                (capitalize (replace-regexp-in-string "\\[_-\\]" " " (file-name-base path)))
                                lang
                                (file-relative-name path)))
                (forward-char (cadr (insert-file-contents path)))
                (insert "\n#+" "END_SRC\n"))))

    (defun my/mode->language (mode)
        "Return the language for the given mode"
        (intern (replace-regexp-in-string "\\-mode$" "" (my/->string mode))))

    (defun my/org-babel-untangle-tree (path)
        (interactive "Droot directory to untangle: ")
        (mapc 'my/org-babel-untangle
              (cl-remove-if 'file-directory-p
                            (f-files path (lambda (p) t) t))))


    (defvar my/org-babel-evaluated-languages
        '(emacs-lisp)
        '(python)
        '(julia))

    (org-babel-do-load-languages
     'org-babel-load-languages
     (mapcar (lambda (lang)
                 (cons lang t))
             my/org-babel-evaluated-languages))
    )

(defun set-org-reveal ()
    (require 'ox-reveal)
    (setq org-reveal-root "file:///home/rock/Descargas/revealjs/reveal.js")
    )


(provide 'org-settings)
