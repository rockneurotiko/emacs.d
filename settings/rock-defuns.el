;; -*- lexical-binding: t; -*-

;;; rock-defuns.el -- Miscellaneous functions

;; (defmacro ->> (&rest body)
;;   (let ((result (pop body)))
;;     (dolist (form body result)
;;       (setq result (append form (list result))))))

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

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun package-require (pkg)
  "Install a package only if it's not already installed."
  (when (not (package-installed-p pkg))
    (package-install pkg)))

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

(defun w0w-calculator ()
  "Calculate math expression on current line using calc-eval"
  (interactive)
  (setq cLine
        (buffer-substring-no-properties
         (line-beginning-position)
         (line-end-position)))
  (save-excursion
    (end-of-line)
    (open-line 1))
  (forward-line 1)
  (insert(calc-eval '("evalv($)" calc-internal-prec 18) 'num cLine)))

(defun tws-region-to-process (arg beg end)
  "Send the current region to a process buffer.
The first time it's called, will prompt for the buffer to
send to. Subsequent calls send to the same buffer, unless a
prefix argument is used (C-u), or the buffer no longer has an
active process."
  (interactive "P\nr")
  (if (or arg ;; user asks for selection
          (not (boundp 'tws-process-target)) ;; target not set
          ;; or target is not set to an active process:
          (not (process-live-p (get-buffer-process
                                tws-process-target))))
      (setq tws-process-target
            (completing-read
             "Process: "
             (seq-map (lambda (el) (buffer-name (process-buffer el)))
                      (process-list)))))
  (process-send-region tws-process-target beg end)
  (switch-to-buffer-other-window tws-process-target))

(provide 'rock-defuns)
