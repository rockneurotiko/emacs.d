;; -*- lexical-binding: nil; -*-

(use-package org :ensure nil
  :config

  (require 'org-tempo)
  (setq-default org-src-fontify-natively t)

  (unless (file-exists-p org-directory)
    (make-directory org-directory t))

  (defun rock--org-autodone (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  :custom

  ;; org-capture-template has examples as types, so the setopt
  ;; gives a warning
  (org-capture-templates
      '(("t" "Todo" entry (file+headline (file-name-concat org-directory "roam/capture/todos.org") "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+olp+datetree (file-name-concat org-directory "roam/capture/journal.org"))
         "* %?\nEntered on %U\n  %i\n  %a")))

  :setopt

  (org-directory (expand-file-name "~/Git/orgs"))

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

  (org-tag-alist '((:startgroup . nil)
                   ;; Projects
                   ("auth" . ?a)
                   ("custom_fields" . ?c)
                   ("improvements" . ?i)
                   ("bugfix" . ?f)
                   ("bff" . ?b)
                   (:endgroup . nil)
                   ;; Type
                   (:startgroup . nil)
                   ("@tripservice" . ?t)
                   ("@ex_gram" . ?e)
                   ("@personal" . ?p)
                   ("@graphql_query" . ?g)
                   (:endgroup . nil)))




  (org-refile-targets '((nil :level . 1)
                      (org-agenda-files :level . 1)))


  ;; http://www.farseer.cn/tweak/2014/11/10/org-your-notes/
  (org-calendar-file-personal (file-name-concat org-directory "roam/calendars/personal.org"))
  (org-calendar-file-work (file-name-concat org-directory "roam/calendars/work.org"))
  (org-default-notes-file (file-name-concat org-directory "roam/capture/notes.org"))
  (org-agenda-files `(,org-calendar-file-personal
                      ,org-calendar-file-work
                      ,(file-name-concat org-directory "roam/capture/todos.org")))

  (org-log-done 'time)
  (org-file-apps '((auto-mode . emacs)
                   (directory . emacs)
                   ("\\.mp4\\'" . "xdg-open %s")
                   ("\\.pdf\\'" . "xdg-open %s")))
  (org-startup-with-latex-preview t)
  (org-startup-with-inline-images t)

  (org-agenda-custom-commands '(("n" "Agenda and all TODOs" ((agenda "") (alltodo "")))
                                ("d" "TODOs closed" ((tags "TODO=\"DONE\"&CLOSED>=\"<-1w>\""))
                                 ((org-agenda-cmp-user-defined 'org-cmp-closed)
                                  (org-agenda-sorting-strategy '(user-defined-down))))
                                ("p" "Projects"
                                 ((todo "" ((org-agenda-overriding-header "TripService Projects")
                                            (org-super-agenda-groups
                                             ;; '((:auto-tags t))
                                             '((:name "Auth" :and (:tag "@tripservice" :tag "auth") :order 1)
                                               (:name "Custom Fields" :and (:tag "@tripservice" :tag "custom_fields") :order 5)
                                               (:name "Improvements" :and (:tag "@tripservice" :tag "improvements") :order 10)
                                               (:name "Bug Fixes" :and (:tag "@tripservice" :tag "bugfix") :order 15)
                                               (:name "BFF favors" :and (:tag "@tripservice" :tag "bff") :order 20)
                                               (:name "Other TripService projects" :tag "@tripservice" :order 25)
                                               (:discard (:anything t))
                                               ))))))))

  :hook
  (org-after-todo-statistics . rock--org-autodone)

  :bind
  (("C-c l" . org-store-link)
   ("C-c c" . org-capture)
   ("C-c a" . org-agenda)
   ("C-c b" . org-switchb))
  )

(use-package org-super-agenda
  :ensure t
  :after org
  :custom
  (org-super-agenda-groups
   '(;; Each group has an implicit boolean OR operator between its selectors.
     (:name "Today"  ; Optionally specify section name
            :time-grid t  ; Items that appear on the time grid
            :todo ("TODAY" "IN PROGRESS")
            :order 1)  ; Items that have this TODO keyword
     (:name "To Deploy"  ; Optionally specify section name
            :time-grid t  ; Items that appear on the time grid
            :todo ("UPLOAD")
            :order 2)  ; Items that have this TODO keyword
     (:name "Important"
            ;; Single arguments given alone
            :tag "important"
            :priority "1"
            :order 3)

     (:name "To deploy" :todo "UPLOAD" :order 4)
     (:name "In QA" :todo "QA" :order 5)
     (:name "In code review" :todo "CODE REVIEW" :order 6)
     (:todo ("BLOCKED" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
            ;; Show this group at the end of the agenda (since it has the
            ;; highest number). If you specified this group last, items
            ;; with these todo keywords that e.g. have priority A would be
            ;; displayed in that group instead, because items are grouped
            ;; out in the order the groups are listed.
            :order 10)
     (:priority<= "2"
                  ;; Show this section after "Today" and "Important", because
                  ;; their order is unspecified, defaulting to 0. Sections
                  ;; are displayed lowest-number-first.
                  :order 20)
     ;; After the last group, the agenda will display items that didn't
     ;; match any of these groups, with the default order position of 99
     ))
  :config
  (org-super-agenda-mode))

(use-package org-download
  :ensure t
  :config
  (defun rock--org-roam-download-directory ()
    "Set `org-download-image-dir` to the directory of the currentbuffer's file."
    (if (not (buffer-file-name))
        (setq-local org-download-image-dir (concat org-directory "images/"))

      (setq-local org-download-image-dir (concat (file-name-directory  (buffer-file-name)) (file-name-base buffer-file-name) "/images/") )))
  :hook
  (org-mode . rock--org-roam-download-directory)
  :setopt
  ;; (org-download-method 'attach)
  (org-download-method 'directory))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam
  :ensure t
  :after org
  :setopt
  (org-roam-directory (file-truename (file-name-concat org-directory "roam")))
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
  (org-roam-db-autosync-mode))

;; CALENDAR settings

(use-package org-gcal
  :ensure t

  :init
  (setq plstore-cache-passphrase-for-symmetric-encryption t)
  ;; (add-to-list org-agenda-files "~/Git/orgs/calendars/personal.org")

  :setopt
  (org-gcal-client-id  (efs/lookup-password :host "calendar.google.com" :user "client-id"))
  (org-gcal-client-secret  (efs/lookup-password :host "calendar.google.com" :user "client-secret"))
  (org-gcal-fetch-file-alist `(("miguelglafuente@gmail.com" . ,org-calendar-file-personal)
                               ("9afjkjrns5t3orjlidadp53tl6a4j912@import.calendar.google.com" . ,org-calendar-file-work)))

  (org-gcal-local-timezone "Europe/Madrid")
  (request-log-level 'warn))

(use-package calfw
  :ensure t
  :setopt
  (calendar-week-start-day 1) ; 0:Sunday, 1:Monday
  )

(use-package calfw-org
  :ensure t
  :after (calfw org-gcal)
  :config
  (setq cfw:org-overwrite-default-keybinding t)
  (define-key cfw:org-custom-map (kbd "R") 'org-gcal-fetch)
  :bind (("C-c C" . cfw:open-org-calendar))
  )

(use-package verb
  :ensure t
  :after org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(provide 'org-settings)
