(use-package calfw
  :ensure t
  :config
  (require 'calfw-org)
  (require 'calfw-cal)
  ;; (require 'calfw-ical)

  (setq cfw:org-agenda-schedule-args '(:timestamp))

  ;; Month
  (setq calendar-month-name-array
        ["Enero" "Febrero" "Marzo" "Abril" "Mayo" "Junio"  "Julio"
         "Agosto" "Septiembre" "Octubre" "Noviembre" "Diciembre"])
  ;; Week days
  (setq calendar-day-name-array
        ["Domingo" "Lunes" "Martes" "Miercoles" "Jueves" "Viernes" "Sabado"])
  ;; First day of the week
  ;; 0:Sunday, 1:Monday
  (setq calendar-week-start-day 1)

  (defun my-open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      ;; google calendar ICS
      ;; (cfw:ical-create-source "gcal" "https://..../basic.ics" "IndianRed")

      ;; orgmode source
      (cfw:org-create-source "Green")

      ;; diary source
      (cfw:cal-create-source "Orange"))))
  :bind ("C-x c c" . my-open-calendar))

(when (file-readable-p "~/.emacs.d/tokens.el")
  (load "~/.emacs.d/tokens.el"))

(when (and (boundp 'gcal-client-id) (boundp 'gcal-client-secret) (boundp 'gcal-email))
  (use-package org-gcal
    :ensure t
    :config
    (setq org-gcal-client-id gcal-client-id
          org-gcal-client-secret gcal-client-secret
          org-gcal-file-alist `((,gcal-email .  "~/.emacs.d/agenda/gcal.org")))))


;; (require 'calfw-ical)
;; (cfw:open-ical-calendar "http://www.google.com/calendar/ical/.../basic.ics")

(provide 'calendar-settings)
