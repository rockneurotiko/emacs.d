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

(setq org-agenda-files (list "~/Dropbox/ORG/work.org"
                             "~/Dropbox/ORG/school.org"
                             "~/Dropbox/ORG/home.org"
                             ;; "~/.emacs.d/agenda/basic.org"
                             "~/.emacs.d/agenda/gcal.org"))
(setq org-agenda-include-diary t)

(defun my-org-autodone (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'my-org-autodone)

(setq org-refile-targets '((nil :level . 1)
                           (org-agenda-files :level . 1)))
(setq-default org-src-fontify-natively t)

;; http://www.farseer.cn/tweak/2014/11/10/org-your-notes/
(setq org-directory "~/docs/org")
(unless (file-exists-p org-directory)
  (make-directory org-directory t))
(setq org-log-done nil)
(setq org-file-apps '((auto-mode . emacs24)
                      ("\\.mp4\\'" . "xdg-open %s")
                      ("\\.pdf\\'" . "xdg-open %s")))
(setq org-startup-with-latex-preview)
(setq org-startup-with-inline-images)

(use-package flyspell
  :ensure t
  :config
  (add-hook 'org-mode-hook 'flyspell-mode))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook
          (lambda ()
            ;; Register " as verbatim
            ;; http://permalink.gmane.org/gmane.emacs.orgmode/82669
            (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n,'")
            (custom-set-variables `(org-emphasis-alist ', org-emphasis-alist))))


(defun helm-org()
  (use-package helm-flyspell
    :ensure t
    :config (define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct)))

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

  (setq my/org-babel-evaluated-languages
    '(emacs-lisp python haskell sh))

  (org-babel-do-load-languages
   'org-babel-load-languages
   (mapcar (lambda (lang)
             (cons lang t))
           my/org-babel-evaluated-languages)))

(defun set-org-reveal ()
  ;; This will let us use syntax colors in code blocks
  (use-package htmlize
    :ensure t)
  (use-package ox-reveal
    :ensure t
    :init (setq org-reveal-root (concat "file://" (expand-file-name "~/.emacs.d/plugins/revealjs")))))

(defun set-ditaa ()
  (setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0_9.jar")
  ;; this line activates ditaa
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ditaa . t))))

(defun enable-beamer ()
  ;; allow for export=>beamer by placing

  ;; #+LaTeX_CLASS: beamer in org files

  (require 'ox-latex)
  (add-to-list 'org-latex-classes
               '("beamer"
                 "\\documentclass\[presentation\]\{beamer\}"
                 ("\\section\{%s\}" . "\\section*\{%s\}")
                 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t))))


;; (setq org-modules '(org-bbdb
;;                     org-gnus
;;                     org-drill
;;                     org-info
;;                     org-jsinfo
;;                     org-habit
;;                     org-irc
;;                     org-mouse
;;                     org-protocol
;;                     org-annotate-file
;;                     org-eval
;;                     org-expiry
;;                     org-interactive-query
;;                     org-man
;;                     org-collector
;;                     org-panel
;;                     org-screen
;;                     org-toc))
;; (eval-after-load 'org
;;     '(org-load-modules-maybe t))
;; (setq org-expiry-inactive-timestamps t)

;; (bind-key "C-c r" 'org-capture)
;; (bind-key "C-c a" 'org-agenda)
;; (bind-key "C-c l" 'org-store-link)
;; (bind-key "C-c L" 'org-insert-link-global)
;; (bind-key "C-c O" 'org-open-at-point-global)
;; (bind-key "<f9> <f9>" 'org-agenda-list)
;; (bind-key "<f9> <f8>" (lambda () (interactive) (org-capture nil "r")))
;; (bind-key "C-TAB" 'org-cycle org-mode-map)
;; (bind-key "C-c v" 'org-show-todo-tree org-mode-map)
;; (bind-key "C-c C-r" 'org-refile org-mode-map)
;; (bind-key "C-c R" 'org-reveal org-mode-map)

;; (eval-after-load 'org
;;     '(bind-key "C-M-w" 'append-next-kill org-mode-map))

;; (eval-after-load 'org-agenda
;;     '(bind-key "i" 'org-agenda-clock-in org-agenda-mode-map))

;; (setq org-goto-interface 'outline
;;       org-goto-max-level 10)
;; (require 'imenu)
;; (setq org-startup-folded nil)
;; (bind-key "C-c j" 'org-clock-goto) ;; jump to current task from anywhere
;; (bind-key "C-c C-w" 'org-refile)
;; (setq org-cycle-include-plain-lists 'integrate)

(setq org-default-notes-file "~/docs/org/organizer.org")

;; (defun my/yank-more ()
;;     (interactive)
;;     (insert "[[")
;;     (yank)
;;     (insert "][more]]"))
;; (global-set-key (kbd "<f6>") 'my/yank-more)


(provide 'org-settings)
