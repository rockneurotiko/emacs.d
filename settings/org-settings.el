;;; org-settings.el --- Org-mode configuration -*- lexical-binding: t; -*-

(defconst rock--todo-colors
  '(("TODO"        . "red")
    ("IN PROGRESS" . "cyan")
    ("BLOCKED"     . "orange")
    ("CODE REVIEW" . "purple")
    ("QA"          . "green")
    ("UPLOAD"      . "magenta")
    ("DONE"        . "forest green")
    ("CANCELED"    . "gray")))

(defun rock/todo-fg-face (color)
  `(:foreground ,color :weight bold))

;; --- Agent tickets ---------------------------------------------------
;; Tickets written by `org-ticket' live in org-roam feature nodes. The agenda
;; groups them by feature; these two helpers drive that view.

(defconst rock/org-ticket-state-order
  '("IN PROGRESS" "TODO" "CODE REVIEW" "QA" "UPLOAD" "BLOCKED")
  "Order tickets appear in within a feature: doing, to do, review, blocked last.")

(defun rock/org-ticket--rank (item)
  "Rank agenda ITEM by its todo keyword, unknown keywords last."
  (or (cl-position (get-text-property 0 'todo-state item)
                   rock/org-ticket-state-order :test #'equal)
      99))

(defun rock/org-ticket-cmp (a b)
  "Compare agenda items A and B by `rock/org-ticket-state-order'."
  (let ((ra (rock/org-ticket--rank a))
        (rb (rock/org-ticket--rank b)))
    (cond ((< ra rb) -1)
          ((> ra rb) +1))))

(defun rock/org-ticket-feature-name (_item)
  "Return the feature node's title, plus its own ADO ids when it has any.
Called by org-super-agenda auto-groups with the item's buffer current."
  (let ((title (or (cadr (assoc "TITLE" (org-collect-keywords '("TITLE"))))
                   "Unfiled"))
        (ado (org-entry-get (point-min) "ADO")))
    (if (and ado (not (string-empty-p ado)))
        (format "%s  [ADO %s]" title ado)
      title)))

(defun rock/org-feature-file-mtime (file)
  "Return FILE's last-modified time, or the epoch when it has none."
  (or (and file (file-exists-p file)
           (file-attribute-modification-time (file-attributes file)))
      '(0 0)))

(defun rock/org-super-agenda-group-by-feature-mtime (all-items &rest _args)
  "Group ALL-ITEMS into one section per feature, newest-touched file first.
A registered org-super-agenda auto-group, like `:auto-map' but ordered
by the feature file's mtime instead of alphabetically by name, so the
Agent tickets view surfaces whatever feature was worked on most recently."
  (let ((items-by-feature (make-hash-table :test #'equal))
        (file-by-feature (make-hash-table :test #'equal)))
    (dolist (item all-items)
      (let* ((marker (org-super-agenda--get-marker item))
             (feature (org-super-agenda--when-with-marker-buffer marker
                        (rock/org-ticket-feature-name item))))
        (when feature
          (push item (gethash feature items-by-feature))
          (unless (gethash feature file-by-feature)
            (puthash feature (buffer-file-name (marker-buffer marker))
                     file-by-feature)))))
    (let* ((features (cl-loop for k being the hash-keys of items-by-feature collect k))
           (mtime (lambda (feature)
                    (rock/org-feature-file-mtime (gethash feature file-by-feature))))
           (newest-first (sort features
                               (lambda (a b) (time-less-p (funcall mtime b) (funcall mtime a))))))
      (list :auto-feature-mtime
            nil
            (cl-loop for f in newest-first
                     collect (list :name f
                                   :items (nreverse (gethash f items-by-feature))))))))

(defun rock/org-agent-feature-file-p (file)
  "Return non-nil when FILE's org header tags it as an agent feature.
Only the first 4k of the file is read, so this stays cheap over a whole
org-roam directory: `#+filetags:' always lives in the header."
  (with-temp-buffer
    (insert-file-contents file nil 0 4096)
    (goto-char (point-min))
    (re-search-forward "^#\\+filetags:.*:AgentFeature:" nil t)))

(defun rock/org-agent-feature-files ()
  "Return the org-roam files that hold agent feature nodes.
Used as `org-agenda-files' for the agent ticket view so the agenda scans
only feature files instead of every roam note."
  (seq-filter #'rock/org-agent-feature-file-p
              (directory-files-recursively org-roam-directory "\\.org\\'")))

(defun rock/org-ticket-ado-prefix ()
  "Agenda prefix cell showing the ticket's *own* ADO ids.
Inherited feature-level ids are deliberately omitted: they are stated
once in the group header instead of repeated on every line."
  (let ((ado (org-entry-get nil "ADO")))
    (if (and ado (not (string-empty-p ado)))
        (format "ADO#%s" ado)
      "")))

;; Closing a ticket by hand should free whatever it blocked, exactly as
;; `org-ticket done' does from the CLI. The tracker backend ships with the
;; skill and is deliberately never loaded from init.el, so load it on demand
;; and let no failure in it break an ordinary TODO state change.
(defconst rock/org-tracker-file
  (expand-file-name "~/.agents/skills/org-tracker/scripts/org-tracker.el")
  "Path to the `org-ticket' backend that owns ticket blocking edges.")

(defun rock/org-tracker-unblock-dependents ()
  "Flip tickets blocked by the entry at point to TODO once it closes.
Cheap file-tag test first, so ordinary org files never load the backend."
  (when (and (derived-mode-p 'org-mode)
             (member "AgentFeature" (bound-and-true-p org-file-tags)))
    (condition-case err
        (progn
          (unless (fboundp 'org-tracker-unblock-dependents)
            (load rock/org-tracker-file nil t))
          (org-tracker-unblock-dependents))
      (error (message "org-tracker: auto-unblock failed (%s)"
                      (error-message-string err))))))

;; Azure DevOps work items are referenced by bare id; this makes
;; [[ado:31819]] clickable anywhere in org.
(defvar rock/org-ado-url-format
  "https://dev.azure.com/fctg-corp/TripServices/_workitems/edit/%s"
  "URL template for `ado:' links, taking the work item id.")

(defun rock/org-ado-url (id)
  "Return the Azure DevOps URL for work item ID.
Pure: builds the string and opens nothing, so it is safe to test."
  (format rock/org-ado-url-format (string-trim id)))

(defun rock/org-ado-open (id &optional _arg)
  "Open Azure DevOps work item ID in a browser."
  (browse-url (rock/org-ado-url id)))

(defun rock/todo-bg-face (color)
  (let ((dark-p (member color '("purple" "magenta" "forest green"))))
    `(:background ,color :foreground ,(if dark-p "white" "black") :weight semibold)))

(use-package org :ensure t :demand t
  :config

  (require 'org-tempo)
  (setq-default org-src-fontify-natively t)
  ;; Set priority range here (not via setopt) to avoid the :type validator
  ;; calling org-priority-valid-value-p before org.el is fully loaded.
  (setq org-priority-highest 1
        org-priority-lowest  5
        org-priority-default 4)

  (unless (file-exists-p org-directory)
    (make-directory org-directory t))

  (defun rock--org-autodone (_n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    ;; NOTE: the Org manual's version of this snippet also binds
    ;; `org-log-states', which is not an Org variable and never has been, so
    ;; it is dropped here -- under lexical binding it would just be an inert
    ;; unused local.
    (let (org-log-done)                  ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  :custom

  ;; org-capture-template has examples as types, so the setopt
  ;; gives a warning
  (org-capture-templates
   `(("t" "Todo" entry (file+headline ,(file-name-concat org-directory "roam/capture/todos.org") "Tasks")
      "* TODO %?\n  %i\n  %a")
     ("j" "Journal" entry (file+olp+datetree ,(file-name-concat org-directory "roam/capture/journal.org"))
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
          (mapcar (lambda (kv) (cons (car kv) (rock/todo-fg-face (cdr kv)))) rock--todo-colors))

  ;; These use a :type validator that calls org-priority-valid-value-p at
  ;; setopt time. Use setq instead to avoid triggering the validator before
  ;; org.el is fully loaded.
  ;; (org-priority-highest 1)
  ;; (org-priority-lowest  5)
  ;; (org-priority-default 4)

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
                                               ))))))
                                ;; Agent tickets live in org-roam feature
                                ;; nodes, deliberately outside org-agenda-files
                                ;; so they never crowd the daily agenda.
                                ("g" "Agent tickets"
                                 ((tags-todo "Ticket"
                                             ((org-agenda-overriding-header "Agent tickets")
                                              ;; One section per feature node,
                                              ;; newest-touched feature file
                                              ;; first. org-super-agenda groups
                                              ;; are flat, so state order within
                                              ;; a feature is a sort, not a
                                              ;; second grouping.
                                              (org-super-agenda-groups
                                               '((:auto-feature-mtime t)))
                                              (org-agenda-sorting-strategy '(user-defined-up))
                                              (org-agenda-cmp-user-defined #'rock/org-ticket-cmp)
                                              ;; Drop the filename prefix: the
                                              ;; feature is already the heading.
                                              ;; Keep a fixed ADO column so the
                                              ;; keywords still line up.
                                              (org-agenda-prefix-format
                                               '((tags . "  %-11(rock/org-ticket-ado-prefix) ")))
                                              ;; Hide the tags that are true of
                                              ;; every ticket and say nothing.
                                              (org-agenda-show-inherited-tags nil)
                                              (org-agenda-hide-tags-regexp
                                               "\\`\\(Ticket\\|AgentFeature\\)\\'"))))
                                 ((org-agenda-files (rock/org-agent-feature-files))))))

  :hook
  ((org-after-todo-statistics . rock--org-autodone)
   (org-after-todo-state-change . rock/org-tracker-unblock-dependents))

  :bind
  (("C-c l" . org-store-link)
   ("C-c c" . org-capture)
   ("C-c a" . org-agenda)
   ("C-c b" . org-switchb))
  )

;; Block until Elpaca has fully built and activated the new Org before any
;; org-dependent packages below attempt to load it.
(elpaca-wait)

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
  ;; Registers `:auto-feature-mtime' alongside org-super-agenda's built-in
  ;; `:auto-*' groupers, for the Agent tickets view's newest-first ordering.
  (setq org-super-agenda-group-types
        (plist-put org-super-agenda-group-types
                   :auto-feature-mtime #'rock/org-super-agenda-group-by-feature-mtime))
  (add-to-list 'org-super-agenda-auto-selector-keywords :auto-feature-mtime)
  (org-super-agenda-mode))

(use-package org-download
  :ensure t
  :after org
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

;; Declared so the `let' below is a dynamic binding of org-roam's defcustom
;; even when this file is byte-compiled before org-roam is loaded.
(defvar org-roam-capture-templates)

(defun org-roam-node-insert-immediate (arg &rest args)
  "Insert a link to a node, finishing the capture immediately.
ARG and ARGS are passed through to `org-roam-node-insert'."
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam
  :ensure (:host github :repo "org-roam/org-roam" :depth 1 :files (:defaults "extensions/*"))
  :after org

  :setopt
  (org-roam-directory (file-truename (file-name-concat org-directory "roam")))
  (org-tracker-directory (file-truename (file-name-concat org-directory "roam/tracker")))
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
      "* Info\n\n- Link: %a\n- Saw in: \n\n* Notes:\n\n%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" ":PROPERTIES:\n:ROAM_REFS: ${url}\n:END:\n#+date: %U\n#+title: ${title}\n#+filetags: :Link:")
      :unnarrowed t)

     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Resources\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+date: %U\n#+title: ${title}\n#+filetags: :Project:")
      :unnarrowed t)
     ))

  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

  :bind (("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . rock/org-roam-node-find-notes)
        ("C-c n F" . org-roam-node-find)
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

  ;; Agent tickets carry an :ID:, so org-roam indexes every one of them as a
  ;; node and they flood node-find. `C-c n f' skips them; `C-c n F' shows all.
  (defun rock/org-roam-node-find-notes ()
    "Find an org-roam node, excluding agent tickets."
    (interactive)
    (org-roam-node-find
     nil nil
     (lambda (node) (not (member "Ticket" (org-roam-node-tags node))))))
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

(with-eval-after-load 'org
  (org-link-set-parameters "ado" :follow #'rock/org-ado-open))

;; CALENDAR settings

(use-package org-gcal
  :ensure t
  :after org

  :init
  (setq plstore-cache-passphrase-for-symmetric-encryption t)
  ;; (add-to-list org-agenda-files "~/Git/orgs/calendars/personal.org")

  :setopt
  (org-gcal-client-id  (efs/lookup-password :host "calendar.google.com" :user "client-id"))
  (org-gcal-client-secret  (efs/lookup-password :host "calendar.google.com" :user "client-secret"))
  (org-gcal-fetch-file-alist `(("miguelglafuente@gmail.com" . ,org-calendar-file-personal)
                               ("9afjkjrns5t3orjlidadp53tl6a4j912@import.calendar.google.com" . ,org-calendar-file-work)))
  (org-gcal-remove-api-cancelled-events t)

  (org-gcal-local-timezone "Europe/Madrid")
  (request-log-level 'warn))

(use-package calfw
  :ensure t
  :after org-gcal
  :setopt
  (calendar-week-start-day 1) ; 0:Sunday, 1:Monday
  )

(use-package calfw-org
  :ensure t
  :after (calfw org-gcal)
  :config
  (setq calfw-org-overwrite-default-keybinding t)
  (define-key calfw-org-custom-map (kbd "R") 'org-gcal-fetch)
  :bind (("C-c C" . calfw-org-open-calendar))
  )

(use-package verb
  :ensure t
  :after org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(defun rock/set-org-variables ()
  (setq-local line-spacing 0.4))

(use-package org-modern
  :ensure t
  :after org
  :hook
  (org-mode . org-modern-mode)
  (org-mode . rock/set-org-variables)
  (org-agenda . rock/set-org-variables)
  (org-agenda-finalize . org-modern-agenda)
  :setopt
  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  ;; Org styling, hide markup etc.)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-agenda-tags-column 0)
  (org-ellipsis "…")

  ;; Inverse TODO faces
  (org-modern-todo-faces (mapcar (lambda (kv) (cons (car kv) (rock/todo-bg-face (cdr kv)))) rock--todo-colors))

  (org-modern-hide-stars nil)		; adds extra indentation
  (org-modern-table nil)
  (org-modern-list
   '(;; (?- . "-")
     (?* . "•")
     (?+ . "‣")))
  )

(use-package org-modern-indent
  :ensure (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :after org-modern
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90)
  :setopt
  (org-startup-indented t))

(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode)
  :setopt
  (org-superstar-cycle-headline-bullets t)
  (org-hide-leading-stars t)
  (org-superstar-special-todo-items nil))

(use-package org-autolist
  :ensure t
  :after org
  :hook (org-mode . org-autolist-mode))

;; https://github.com/awth13/org-appear
(use-package org-appear
  :ensure t
  :after org
  :hook (org-mode . org-appear-mode)
  :setopt
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t)
  (org-appear-autokeywords t)
  (org-appear-delay 1))

;; Work around upstream flycheck bug: the org-lint checker passes the
;; line number from `org-lint' (a propertized string) directly to
;; `flycheck-error-new-at', which expects an integer.
;; TODO: Remove once flycheck PR #2165 is merged
;; https://github.com/flycheck/flycheck/pull/2165
(with-eval-after-load 'flycheck
  (flycheck-define-generic-checker 'org-lint
    "An Org mode syntax checker using `org-lint'."
    :start (lambda (checker callback)
             (condition-case err
                 (let ((errors
                        (delq nil
                              (mapcar
                               (lambda (e)
                                 (pcase e
                                   (`(,_n [,line ,_trust ,desc ,_checker])
                                    (flycheck-error-new-at
                                     (if (stringp line)
                                         (string-to-number line)
                                       line)
                                     nil 'info desc :checker checker))
                                   (_
                                    (flycheck-error-new-at
                                     1 nil 'warning
                                     (format "Unexpected org-lint format: %S" e)
                                     :checker checker))))
                               (org-lint)))))
                   (funcall callback 'finished errors))
               (error (funcall callback 'errored
                               (error-message-string err)))))
    :modes '(org-mode)
    :enabled #'flycheck-org-lint-available-p
    :verify (lambda (_)
              (let ((org-version (when (require 'org nil 'no-error)
                                   (org-version))))
                (list (flycheck-verification-result-new
                       :label "Org-lint available"
                       :message (if (fboundp 'org-lint)
                                    (format "yes (Org %s)" org-version)
                                  "no")
                       :face (if (fboundp 'org-lint) 'success 'warning)))))))

;; (use-package orgnote
;;   :ensure (:host github :repo "Artawower/orgnote.el" :branch "dev")
;;   :bind
;;   (("C-c n p" . orgnote-publish-file)
;;    ("C-c n F" . orgnote-force-sync)
;;    ("C-c n S" . orgnote-sync))
;;   :hook (org-mode . orgnote-autosync-mode)
;;   :custom
;;   (orgnote-debug-p t)
;;   (orgnote-enable-roam-sync-p t))

(provide 'org-settings)
