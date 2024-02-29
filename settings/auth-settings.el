(require 'auth-source)

(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))
;;; use the Secrets API Login collection
;;; (see Secret Service API)
(setq auth-sources '("secrets:Login"))
;;; use pass (~/.password-store)
;;; (see The Unix password store)
(auth-source-pass-enable)
;;; JSON data in format [{ "machine": "SERVER",
;;; "login": "USER", "password": "PASSWORD" }...]
;; (setq auth-sources '("~/.authinfo.json.gpg"))


(defun efs/lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))

(provide 'auth-settings)
