(require 'gnus)

(setq user-mail-address "miguelglafuente@gmail.com"
      user-full-name    "Rock Neurotiko")

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "miguelglafuente@gmail.com" nil) ("smtp.gmail.com" 587 "mgarcia@conwet.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)


(require 'gnus-autocheck)

;; automatic check every 2 minutes for new incoming mails
(setq gnus-autocheck-interval (* 60 2))

;; autocheck should not run between 8:30AM and 6PM during work days
(setq gnus-autocheck-active-periods '(("08:00" "14:00") ("14:00" "20:00")))

(use-package gnus-desktop-notify
  :ensure t
  :init
  (gnus-desktop-notify-mode)
  (gnus-demon-add-scanmail))


(defun setimap ()
  (setq nnml-directory "~/gmail")
  (setq message-directory "~/gmail")

  ;; You need this to be able to list all labels in gmail
  (setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\”]\”[#’()]")
  ;; (setq gnus-ignored-newsgroups "")

  ;; And this to configure gmail imap

  (setq gnus-use-cache t)

  (setq gnus-select-method
        '(nnimap "gmail"
                 (nnimap-address "imap.gmail.com")
                 (nnimap-server-port 993)
                 (nnimap-stream ssl))))


(defun setfrommaildir ()
  "Don't work yet =D"
  (require 'gnus)

  (setq nnml-directory "~/Maildir/")
  (setq gnus-select-method '(nnml ""))

  ;; (setq
  ;;  gnus-select-method '(nnmaildir "Gmail" (directory "~/Maildir/") (get-new-mail nil))
  ;;  mail-sources nil
  ;;  )
  ;; (setq gnus-secondary-select-methods nil)
  )

(defun setpop3 ()
  "Don't work yet :)"
  (require 'gnus)
  (setq gnus-select-method '(nnml ""))

  (setq mail-sources '((pop :server "pop.gmail.com"
                            :port 995
                            :user "user@gmail.com"
                            :password "password"
                            :stream ssl))))

(setimap)

(provide 'gnus-settings)
