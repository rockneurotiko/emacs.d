;; -*- lexical-binding: t; -*-

(defun org-cmp-closed (a b)
  (let* ((a-marker (get-text-property 0 'org-marker a))
         (b-marker (get-text-property 0 'org-marker b))
         (now (current-time))
         (a-closed-ts (org-timestamp-from-string
                       (org-entry-get a-marker "CLOSED")))
         (b-closed-ts (org-timestamp-from-string
                       (org-entry-get b-marker "CLOSED")))
         (a-closed-time (or (and a-closed-ts
                                 (org-timestamp-to-time a-closed-ts))
                            now))
         (b-closed-time (or (and b-closed-ts
                                 (org-timestamp-to-time b-closed-ts))
                            now)))
    (cond ((time-less-p b-closed-time a-closed-time) +1)
          ((time-less-p a-closed-time b-closed-time) -1)
          (t nil))))

(use-package org
  :ensure t
  :straight (:type built-in)
  :config

  (require 'org-tempo)
  (setq-default org-src-fontify-natively t)
  (setq org-log-done 'time)

  (defun rock--org-autodone (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  (unless (file-exists-p org-directory)
    (make-directory org-directory t))

  :custom
  ;; Stop org-mode from highjacking shift-cursor keys
  (org-replace-disputed-keys t)
  (org-hide-emphasis-markers t)
  (org-attach-use-inherinance t)
  (org-attach-store-link-p 'attached)

  (org-todo-keywords
   '((sequence "TODO(t)" "IN PROGRESS(p)" "BLOCKED(b)" "CODE REVIEW(r)" "QA(q)" "UPLOAD(u)" "|" "DONE(d)" "CANCELED(c)")))

  (org-todo-keyword-faces
   '(("TODO" . (:foreground "red" :weight bold))
     ("IN PROGRESS" . (:foreground "cyan" :weight bold))
     ("BLOCKED" . (:foreground "orange" :weight bold))
     ("CODE REVIEW" . (:foreground "purple" :weight bold))
     ("QA" . (:foreground "green" :weight bold))
     ("UPLOAD" . (:foreground "magenta" :weight bold))
     ("DONE" . (:foreground "forest green" :weight bold))
     ("CANCELED" . (:foreground "gray" :weight bold))))

  (org-priority-highest 1)
  (org-priority-lowest  5)
  (org-priority-default 4)

  (org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Git/orgs/roam/capture/todos.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/Git/orgs/roam/capture/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

  (org-refile-targets '((nil :level . 1)
                      (org-agenda-files :level . 1)))


  ;; http://www.farseer.cn/tweak/2014/11/10/org-your-notes/
  (org-directory "~/Git/orgs")
  (org-default-notes-file "~/Git/orgs/roam/capture/notes.org")
  (org-agenda-files '("~/Git/orgs/roam/calendars/personal.org" "~/Git/orgs/roam/calendars/work.org" "~/Git/orgs/roam/capture/todos.org"))

  (org-log-done nil)
  (org-file-apps '((auto-mode . emacs)
                   (directory . emacs)
                   ("\\.mp4\\'" . "xdg-open %s")
                   ("\\.pdf\\'" . "xdg-open %s")))
  (org-startup-with-latex-preview t)
  (org-startup-with-inline-images t)

  (org-agenda-custom-commands '(("n" "Agenda and all TODOs" ((agenda "") (alltodo "")))
                                     ("d" "TODOs closed" ((tags "TODO=\"DONE\"&CLOSED>=\"<-1w>\""))
                                      ((org-agenda-cmp-user-defined 'org-cmp-closed)
                                       (org-agenda-sorting-strategy '(user-defined-down))))))


  :init
  ;; https://orgmode.org/worg/org-contrib/babel/languages/
  (org-babel-do-load-languages 'org-babel-load-languages '((dot . t)))

  :hook
  ((org-after-todo-statistics . rock--org-autodone)
   (org-mode . flyspell-mode)
   (org-mode . visual-line-mode))

  :bind
  (("C-c l" . org-store-link)
   ("C-c c" . org-capture)
   ("C-c a" . org-agenda)
   ("C-c b" . org-switchb)))

(use-package org-download
  :ensure t
  :custom
  (org-download-method 'attach))

(use-package flyspell-correct
  :ensure t
  :after flyspell
  :bind (:map flyspell-mode-map (("C-c p p" . flyspell-correct-at-point)
                                 ("C-;" . flyspell-correct-wrapper) )))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam
  :ensure t
  :after org
  :custom
  (org-roam-directory (file-truename "~/Git/orgs/roam"))
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:30}" 'face 'org-tag)))

  (org-roam-mode-sections
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            ;; #'org-roam-unlinked-references-section
            ))

  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+date: %U\n#+title: ${title}\n")
      :unnarrowed t)

     ("l" "link" plain
      "* Info\n\n- Link: %c%? \n- Saw in: \n\n* Notes:\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" ":PROPERTIES:\n:ROAM_REFS: %^{Link}\n:END:\n#+date: %U\n#+title: ${title}\n#+filetags: :Link:")
      :unnarrowed t)

     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Resources\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+date: %U\n#+title: ${title}\n#+filetags: :Project:")
      :unnarrowed t)
     ))

  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

  :bind (("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        ("C-c n I" . org-roam-node-insert-immediate)
        ("C-c n t" . org-roam-tag-add)
        ("C-c n T" . org-roam-tag-remove)
        :map org-roam-refs-map
        ("a" . org-roam-ref-add)
        ("f" . org-roam-ref-find)
        ("r" . org-roam-ref-remove)
        :map org-mode-map
        ("C-c p p" . completion-at-point)
        :map org-roam-dailies-map
        ("Y" . org-roam-dailies-capture-yesterday)
        ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  ("C-c n r" . org-roam-refs-map)
  :init
  (defvar org-roam-refs-map (make-sparse-keymap))
  (define-prefix-command 'org-roam-refs-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode)
  )


(use-package org-roam-ui
  :ensure t
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))


;; If any TODO is marked as DONE, copy it to today's file
;; (defun my/org-roam-copy-todo-to-today ()
;;   (interactive)
;;   (let ((org-refile-keep t) ;; Set this to nil to delete the original!
;;         (org-roam-dailies-capture-templates
;;           '(("t" "tasks" entry "%?"
;;              :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
;;         (org-after-refile-insert-hook #'save-buffer)
;;         today-file
;;         pos)
;;     (save-window-excursion
;;       (org-roam-dailies--capture (current-time) t)
;;       (setq today-file (buffer-file-name))
;;       (setq pos (point)))

;;     ;; Only refile if the target file is different than the current file
;;     (unless (equal (file-truename today-file)
;;                    (file-truename (buffer-file-name)))
;;       (org-refile nil nil (list "Tasks" today-file nil pos)))))

;; (add-to-list 'org-after-todo-state-change-hook
;;              (lambda ()
;;                (when (equal org-state "DONE")
;;                  (my/org-roam-copy-todo-to-today))))



;; (use-package helm-flyspell
;;   :ensure t
;;   :config (define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct))

(use-package org-bullets
  :ensure t
  :after (org)
  :hook
  (org-mode . org-bullets-mode))

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             ;; Register " as verbatim
;;             ;; http://permalink.gmane.org/gmane.emacs.orgmode/82669
;;             (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n,'")
;;             (custom-set-variables `(org-emphasis-alist ', org-emphasis-alist))))

;; This will let us use syntax colors in code blocks
(use-package htmlize
  :ensure t)



;; (defun set-ditaa ()
;;   (setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0_9.jar")
;;   ;; this line activates ditaa
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((ditaa . t))))


;; LaTeX configs

;; (defun enable-beamer ()
;;   ;; allow for export=>beamer by placing

;;   ;; #+LaTeX_CLASS: beamer in org files

;;   (require 'ox-latex)
;;   (add-to-list 'org-latex-classes
;;                '("beamer"
;;                  "\\documentclass\[presentation\]\{beamer\}"
;;                  ("\\section\{%s\}" . "\\section*\{%s\}")
;;                  ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
;;                  ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((latex . t))))

;; (add-to-list 'org-latex-packages-alist '("newfloat" "minted"))
;; (setq org-latex-listings 'minted)

;; (setq org-latex-pdf-process
;;       '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "bibtex %b"
;;         ;; "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; (setq bibtex-autokey-year-length 4
;;       bibtex-autokey-name-year-separator "-"
;;       bibtex-autokey-year-title-separator "-"
;;       bibtex-autokey-titleword-separator "-"
;;       bibtex-autokey-titlewords 2
;;       bibtex-autokey-titlewords-stretch 1
;;       bibtex-autokey-titleword-length 5)


;; (add-to-list 'org-latex-default-packages-alist '("" "natbib" "") t)

;; (add-to-list 'org-latex-default-packages-alist
;;              '("linktocpage,pdfstartview=FitH,colorlinks,
;; linkcolor=blue,anchorcolor=blue,
;; citecolor=blue,filecolor=blue,menucolor=blue,urlcolor=blue"
;;                "hyperref" nil)
;;              t)

(provide 'org-settings)
