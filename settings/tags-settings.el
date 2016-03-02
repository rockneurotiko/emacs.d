(setq tags-table-list '("~/.emacs.d/tags/TAGS"))


(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (eshell-command
     ;; (format "ctags -e -R --exclude=.git --exclude=node_modules --exclude=bower_components -f %s %s" "~/.emacs.d/tags/TAGS" dir-name)
     (format "ctags -e -R --exclude=.git --exclude=node_modules --exclude=bower_components %s" dir-name)))

;; (setq path-to-ctags "~/.emacs.d/tags/TAGS") ;; <- your ctags path here

;; (defun create-tags (dir-name)
;;     "Create tags file."
;;     (interactive "DDirectory: ")
;;     (shell-command
;;      (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
;;     )

(provide 'tags-settings)
