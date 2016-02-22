(setq tags-table-list '("~/.emacs.d/tags/TAGS"))

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (eshell-command
     (format "gentabs" dir-name)))

;; (setq path-to-ctags "~/.emacs.d/tags/TAGS") ;; <- your ctags path here

;; (defun create-tags (dir-name)
;;     "Create tags file."
;;     (interactive "DDirectory: ")
;;     (shell-command
;;      (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
;;     )

(provide 'tags-settings)
