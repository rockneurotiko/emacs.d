;;; auto-package-update-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "auto-package-update" "auto-package-update.el"
;;;;;;  (21795 40085 601440 812000))
;;; Generated autoloads from auto-package-update.el

(autoload 'auto-package-update-now "auto-package-update" "\
Update installed Emacs packages.

\(fn)" t nil)

(autoload 'auto-package-update-maybe "auto-package-update" "\
Update installed Emacs packages if at least `auto-package-update-interval' days have passed since the last update.

\(fn)" nil nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; auto-package-update-autoloads.el ends here
