;;; ensime-notes.el --- Compiler Notes (Error/Warning overlays)

;; Note: This might better be a connection-local variable, but
;; afraid that might lead to hanging overlays..

(defvar ensime-note-overlays '()
  "The overlay structures created to highlight notes.")

(defun ensime-all-notes ()
  (append (ensime-scala-compiler-notes (ensime-connection))
	  (ensime-java-compiler-notes (ensime-connection))))


(defun ensime-add-notes (lang result)
  (let ((is-full (plist-get result :is-full))
	(notes (plist-get result :notes)))
    (cond
     ((equal lang 'scala)
      (setf (ensime-scala-compiler-notes (ensime-connection))
	    (append
	     (ensime-scala-compiler-notes (ensime-connection))
	     notes)))

     ((equal lang 'java)
      (setf (ensime-java-compiler-notes (ensime-connection))
	    (append
	     (ensime-java-compiler-notes (ensime-connection))
	     notes))))

    (ensime-make-note-overlays notes)
    (ensime-update-note-counts)
    ))


(defun ensime-clear-notes (lang)
  (cond
   ((equal lang 'scala)
    (setf (ensime-scala-compiler-notes (ensime-connection)) nil))
   ((equal lang 'java)
    (setf (ensime-java-compiler-notes (ensime-connection)) nil)))
  (ensime-clear-note-overlays lang)
  (ensime-update-note-counts))


(defun ensime-make-overlay-at (file line b e msg visuals)
  "Create an overlay highlighting the given line in
any buffer visiting the given file."
  (let ((beg b)
        (end e))
    (assert (or (integerp line)
                (and (integerp beg) (integerp end))))
    (when-let (buf (find-buffer-visiting file))
              (with-current-buffer buf
                (if (and (integerp beg) (integerp end))
                    (progn
                      (setq beg (ensime-internalize-offset beg))
                      (setq end (ensime-internalize-offset end)))
                  ;; If line provided, use line to define region
                  (save-excursion
                    (goto-line line)
                    (setq beg (point-at-bol))
                    (setq end (point-at-eol)))))

              (ensime-make-overlay beg end msg visuals nil buf))
    ))


(defun ensime-make-note-overlays (notes)
  (dolist (note notes)
    (destructuring-bind
        (&key severity msg beg end line col file &allow-other-keys) note

      ;; No empty note overlays!
      (when (eq beg end)
        (setq end (+ end 1)))

      (let ((lang
             (cond
              ((ensime-java-file-p file) 'java)
              ((ensime-scala-file-p file) 'scala)
              (t 'scala)))
            (visuals
             (cond
              ((equal severity 'error)
               (list :face 'ensime-errline-highlight
		     :char "!"
		     :bitmap 'exclamation-mark
		     :fringe 'ensime-compile-errline))
              (t
               (list :face 'ensime-warnline-highlight
		     :char "?"
		     :bitmap 'question-mark
		     :fringe 'ensime-compile-warnline)))))

        (when-let (ov (ensime-make-overlay-at file line beg end msg visuals))
                  (overlay-put ov 'lang lang)
                  (push ov ensime-note-overlays))

        ))))


(defun ensime-update-note-counts ()
  (let ((notes (ensime-all-notes))
	(num-err 0)
	(num-warn 0)
	(conn (ensime-connection)))
    (dolist (note notes)
      (let ((severity (plist-get note :severity)))
	(cond
	 ((equal severity 'error)
	  (incf num-err))
	 ((equal severity 'warn)
	  (incf num-warn))
	 (t))))
    (setf (ensime-num-errors conn) num-err)
    (setf (ensime-num-warnings conn) num-warn)))


(defun ensime-refresh-all-note-overlays ()
  (let ((notes (when (ensime-connected-p)
		   (append
		    (ensime-java-compiler-notes (ensime-connection))
		    (ensime-scala-compiler-notes (ensime-connection)))
		 )))
    (ensime-clear-note-overlays)
    (ensime-make-note-overlays notes)
    ))

(defface ensime-errline-highlight
  '((t (:inherit flymake-errline)))
  "Face used for marking the specific region of an error, if available."
  :group 'ensime-ui)

(defface ensime-warnline-highlight
  '((t (:inherit flymake-warnline)))
  "Face used for marking the specific region of an warning, if available."
  :group 'ensime-ui)

(defun ensime-make-overlay (beg end tooltip-text visuals &optional mouse-face buf)
  "Allocate a ensime overlay in range BEG and END."
  (let ((ov (make-overlay beg end buf t t)))
    (overlay-put ov 'face           (plist-get visuals :face))
    (overlay-put ov 'mouse-face     mouse-face)
    (overlay-put ov 'help-echo      tooltip-text)
    (overlay-put ov 'ensime-overlay  t)
    (overlay-put ov 'priority 100)
    (let ((char (plist-get visuals :char)))
      (when char
        (overlay-put ov 'before-string
                     (propertize char
                      'display
                      (list 'left-fringe
                            (plist-get visuals :bitmap)
                            (plist-get visuals :fringe))))))
    ov))

(defun ensime-overlays-at (point)
  "Return list of overlays of type 'ensime-overlay at point."
  (let ((ovs (overlays-at point)))
    (remove-if-not
     (lambda (ov) (overlay-get ov 'ensime-overlay))
     ovs)
    ))

(defun ensime-clear-note-overlays (&optional lang)
  "Delete note overlays language. If lang is nil, delete all
 overlays."
  (let ((revised '()))
    (dolist (ov ensime-note-overlays)
      (if (or (null lang)
	      (equal lang (overlay-get ov 'lang)))
	  (delete-overlay ov)
	(setq revised (cons ov revised))))
    (setq ensime-note-overlays revised)))

(defun ensime-next-note-in-current-buffer (notes forward)
  (let ((best-note nil)
	(best-dist most-positive-fixnum)
        (external-offset (ensime-externalize-offset (point)))
        (max-external-offset (ensime-externalize-offset (point-max))))
    (dolist (note notes)
      (if (and (ensime-files-equal-p (ensime-note-file note)
				     buffer-file-name)
	       (/= (ensime-note-beg note) external-offset))
	  (let ((dist (cond
		       (forward
			(if (< (ensime-note-beg note) external-offset)
			    (+ (ensime-note-beg note)
			       (- max-external-offset external-offset))
			  (- (ensime-note-beg note) external-offset)))

		       (t (if (> (ensime-note-beg note) external-offset)
			      (+ external-offset (- max-external-offset
                                                    (ensime-note-beg note)))
			    (- external-offset (ensime-note-beg note)))))))

	    (when (< dist best-dist)
	      (setq best-dist dist)
	      (setq best-note note))
	    )))
    best-note))

(defun ensime-goto-next-note (forward)
  "Helper to move point to next note. Go forward if forward is non-nil."
  (let* ((conn (ensime-connection))
	 (notes (append (ensime-java-compiler-notes conn)
			(ensime-scala-compiler-notes conn)))
	 (next-note (ensime-next-note-in-current-buffer notes forward)))
    (if next-note
	(progn
	  (goto-char (ensime-internalize-offset (ensime-note-beg next-note)))
	  (message (ensime-note-message next-note)))
      (message (concat
		"No more compilation issues in this buffer. "
		"Use ensime-typecheck-all [C-c C-c a] to find"
		" all issues, project-wide.")))))

(defun ensime-forward-note ()
  "Goto the next compilation note in this buffer"
  (interactive)
  (ensime-goto-next-note t))

(defun ensime-backward-note ()
  "Goto the prev compilation note in this buffer"
  (interactive)
  (ensime-goto-next-note nil))

(defun ensime-errors-at (point)
  (delq nil (mapcar (lambda (x) (overlay-get x 'help-echo)) (ensime-overlays-at point))))

(defun ensime-print-errors-at-point ()
  (interactive)
  (let ((msgs (apply 'concat (ensime-errors-at (point)))))
    (when msgs
      (message msgs))))

(provide 'ensime-notes)

;; Local Variables:
;; no-byte-compile: t
;; End:
