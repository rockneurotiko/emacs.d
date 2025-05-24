;; -*- lexical-binding: t; -*-
(use-package plstore
  :ensure t
  :straight (:type built-in)
  :init
  (setq plstore-encrypt-to nil)
  (add-to-list 'plstore-encrypt-to "7BEE07DBE45D6326")
  )

(use-package org-gcal
  :ensure t

  :init
  (setq plstore-cache-passphrase-for-symmetric-encryption t)
  ;; (add-to-list org-agenda-files "~/Git/orgs/calendars/personal.org")

  :custom
  (org-gcal-client-id  (efs/lookup-password :host "calendar.google.com" :user "client-id"))
  (org-gcal-client-secret  (efs/lookup-password :host "calendar.google.com" :user "client-secret"))
  (org-gcal-fetch-file-alist '(("miguelglafuente@gmail.com" . "~/Git/orgs/roam/calendars/personal.org") ("9afjkjrns5t3orjlidadp53tl6a4j912@import.calendar.google.com" . "~/Git/orgs/roam/calendars/work.org")))
  (org-gcal-local-timezone "Europe/Madrid")
  (request-log-level 'debug))


(use-package calfw
  :ensure t
  :custom
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


(provide 'calendar-settings)
