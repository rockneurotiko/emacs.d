;;; rock-defuns.el -- Miscellaneous functions

(defmacro ->> (&rest body)
  (let ((result (pop body)))
    (dolist (form body result)
      (setq result (append form (list result))))))

(defmacro -> (&rest body)
  (let ((result (pop body)))
    (dolist (form body result)
      (setq result (append (list (car form) result)
                           (cdr form))))))

(defun file-if-exists (path)
  (if (file-exists-p path) path nil))

(defun font-lock-replace-symbol (mode reg sym)
  (font-lock-add-keywords
   mode `((,reg
           (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                     ,sym 'decompose-region)))))))

(defun add-hooks (modes func)
  (dolist (mode modes)
    (add-hook (intern (concat (symbol-name mode) "-hook")) func)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun shift-region (numcols)
  (setq region-start (region-beginning))
  (setq region-finish (region-end))
  (save-excursion
    (if (< (point) (mark)) (exchange-point-and-mark))
    (let ((save-mark (mark)))
      (indent-rigidly region-start region-finish numcols))))

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun recompile-init ()
  "Byte-compile all your dotfiles again."
  (interactive)
  (byte-recompile-directory dotfiles-dir 0))

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))


(defun package-require (pkg)
  "Install a package only if it's not already installed."
  (when (not (package-installed-p pkg))
    (package-install pkg)))

;; MINE

;; (defun move-line-up ()
;;   "Move up the current line."
;;   (interactive)
;;   (transpose-lines 1)
;;   (forward-line -2)
;;   (indent-according-to-mode))
;; (defun move-line-down ()
;;   "Move down the current line."
;;   (interactive)
;;   (forward-line 1)
;;   (transpose-lines 1)
;;   (forward-line -1)
;;   (indent-according-to-mode))
;; (global-set-key [(control shift up)]  'move-line-up)
;; (global-set-key [(control shift down)]  'move-line-down)


(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (beginning-of-line)
    (when (or (> arg 0) (not (bobp)))
      (forward-line)
      (when (or (< arg 0) (not (eobp)))
        (transpose-lines arg))
      (forward-line -1)
      (if (< arg 0)
          (forward-line -1))
      (indent-according-to-mode)))
   (indent-according-to-mode)))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))


;; Ctrl enter, new line
(defun sublime-new-line ()
  "Go to next line and indent wherever you are in a line"
  (interactive)
  (end-of-line)
  (newline-and-indent))
;; (global-set-key [C-return] 'sublime-new-line)

;; Comment/uncomment region
(defun comment-or-uncomment-region-or-line ()
  "Like comment-or-uncomment-region, but if there's no mark \(that means no
region\) apply comment-or-uncomment to the current line"
  (interactive)
  (if (not mark-active)
      (comment-or-uncomment-region
       (line-beginning-position) (line-end-position))
    (if (< (point) (mark))
        (comment-or-uncomment-region (point) (mark))
      (comment-or-uncomment-region (mark) (point)))))


(provide 'rock-defuns)
;;; rock-defuns.el ends here
