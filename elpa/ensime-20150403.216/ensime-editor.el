;;; ensime-editor.el  -- Editor and navigation commands


(defun ensime-goto-line (line)
  (goto-char (point-min))
  (forward-line (1- line)))

(defun ensime-line-col-to-point (file line col)
  "Convert line,column coordinates to a char offset."
  (with-temp-buffer
    (insert-file-contents file)
    (ensime-goto-line line)
    (forward-char col)
    (point)))

(defun ensime-current-line ()
  "Return the vertical position of point..."
  (1+ (count-lines 1 (point))))

;; Displaying proposed changes

(defun ensime-insert-change-list (changes)
  "Describe a series of proposed file changes. Used for
 refactoring and undo confirmation buffers."
  (let ((grouped-changed
	 (ensime-group-changes-by-proximity changes)))
    (dolist (ch grouped-changed)
      (let* ((file (plist-get ch :file))
	     (text (plist-get ch :text))
	     (range-start (ensime-internalize-offset-for-file
			   file (plist-get ch :from)))
	     (range-end (ensime-internalize-offset-for-file
			 file (plist-get ch :to)))
	     (edits (plist-get ch :edits)))


	;; Make sure edits is not empty
	(when edits

	  (let* ((edits (copy-list edits));; So we can destructively modify
		 (result (ensime-extract-file-chunk
			  file (- range-start 150) (+ range-end 150)))
		 (chunk-text (plist-get result :text))
		 (chunk-coding-system (plist-get result :chunk-coding-system))
		 (chunk-start (plist-get result :chunk-start))
		 (chunk-end (plist-get result :chunk-end))
		 (chunk-start-line (plist-get result :chunk-start-line)))


	    ;; Sort in reverse textual order
	    ;; so we can apply edits without disturbing
	    ;; positions further down in chunk.
	    (setq edits (sort edits
			      (lambda (a b)
				(> (plist-get a :from)
				   (plist-get b :from)))))

	    ;; Insert heading for chunk

	    (ensime-insert-with-face file 'font-lock-comment-face)
	    (ensime-insert-with-face
	     (format "\n------------------- @line %s -----------------------\n"
		     chunk-start-line)
	     'font-lock-comment-face)

	    (let ((p (point)))
	      (insert chunk-text)

	      ;; Highlight all the edits in the chunk

	      (dolist (ed edits)
		(let* ((text (plist-get ed :text))
		       (from (ensime-internalize-offset-for-file file (plist-get ed :from)))
		       (to (ensime-internalize-offset-for-file file (plist-get ed :to)))
		       (len (- to from)))
		  (goto-char (+ p (- from chunk-start)))
		  (delete-char (min len (- (point-max) (point))))

                  (when (eq 1 (coding-system-eol-type chunk-coding-system))
                    (setq text (replace-regexp-in-string "\r$" "" text)))

                  (let ((start (point)))
                    (insert text)
                    (set-text-properties start (point) '(face font-lock-keyword-face)))))

	      (goto-char (point-max))
	      (insert "\n\n\n"))))))))


(defun ensime-changes-are-proximate-p (ch1 ch2)
  "Return t if ch1 and ch2 occur nearby in the same file."
  (let* ((len1 (- (plist-get ch1 :to)
		  (plist-get ch1 :from)))
	 (mid1 (+ (plist-get ch1 :from) (/ len1 2)))
	 (len2 (- (plist-get ch2 :to)
		  (plist-get ch2 :from)))
	 (mid2 (+ (plist-get ch2 :from) (/ len2 2))))

    (and (equal (plist-get ch1 :file )
		(plist-get ch2 :file ))
	 (< (abs (- mid1 mid2)) 1000))))


(defun ensime-merge-changes (changes)
  "Return a single change with edits that correspond
 to all edits in all elements of changes."
  (let ((range-start most-positive-fixnum)
	(range-end most-negative-fixnum)
	(edits '()))

    (dolist (ch changes)
      (let ((from (plist-get ch :from))
	    (to (plist-get ch :to)))
	(setq range-start (min range-start from))
	(setq range-end (max range-end to))
	(setq edits (append (plist-get ch :edits)
			    edits))))
    (list
     :file (plist-get ch :file)
     :from range-start
     :to range-end
     :edits edits)))


(defun ensime-group-changes-by-proximity (changes)
  "Create aggregate changes for changes that occur nearby
 eachother in the same file."
  (let ((changes
	 (mapcar
	  (lambda (ch)
	    (list
	     :file (plist-get ch :file)
	     :from (plist-get ch :from)
	     :to (plist-get ch :to)
	     :edits (list
		     (list
		      :from (plist-get ch :from)
		      :to (plist-get ch :to)
		      :text (plist-get ch :text)))))
	  changes))
	(merged '()))

    (while changes
      (let ((ch (pop changes))
	    (neighbors '())
	    (update-merged '()))

	(dolist (m merged)
	  (if (ensime-changes-are-proximate-p m ch)
	      (push m neighbors)
	    (push m update-merged)))

	(push (ensime-merge-changes (cons ch neighbors))
	      update-merged)

	(setq merged update-merged)))

    ;; Sort in textual order
    (sort merged (lambda (a b)
		   (< (plist-get a :from)
		      (plist-get b :from))))))


(defun ensime-extract-file-chunk (file-name start end)
  "Return the text of the given file from start to end."
  (with-temp-buffer
    (insert-file-contents file-name)
    (let* ((coding-system last-coding-system-used)
           (chunk-start
            (progn
              (goto-char start)
              (point-at-bol)))
	   (chunk-end
            (progn
              (goto-char end)
              (point-at-eol)))
	   (text (buffer-substring-no-properties chunk-start chunk-end)))
      (list :text text
            :chunk-coding-system coding-system
	    :chunk-start chunk-start
	    :chunk-end chunk-end
	    :chunk-start-line (line-number-at-pos chunk-start)))))



;; Jump to definition


(defun ensime-push-definition-stack ()
  "Add point to find-tag-marker-ring."
  (require 'etags)
  (ring-insert find-tag-marker-ring (point-marker)))

(defun ensime-pop-find-definition-stack ()
  "Pop the edit-definition stack and goto the location."
  (interactive)
  (pop-tag-mark))

(defun ensime-edit-definition-other-window ()
  (interactive)
  (ensime-edit-definition 'window))

(defun ensime-edit-definition-other-frame ()
  (interactive)
  (ensime-edit-definition 'frame))

(defun ensime-edit-definition (&optional where)
  "Lookup the definition of the name at point."
  (interactive)

  (let* ((info (ensime-rpc-symbol-at-point))
	 (pos (ensime-symbol-decl-pos info)))
    (if (ensime-pos-valid-local-p pos)
	(progn
	  (ensime-push-definition-stack)
	  (ensime-goto-source-location pos where))
      (message "Sorry, no definition found."))))


(defun ensime-files-equal-p (f1 f2)
  "Return t if file-names refer to same file."
  (equal (file-truename (expand-file-name f1))
         (file-truename (expand-file-name f2))))


(defun ensime-window-showing-file (file)
  (catch 'result
    (dolist (w (window-list))
      (let* ((buf (window-buffer w))
	     (window-file (buffer-file-name buf)))
	(when (and window-file
		   (ensime-files-equal-p file window-file))
	  (throw 'result w))))))

(defun ensime-window-showing-buffer (buffer)
  (catch 'result
    (dolist (w (window-list))
      (let* ((buf (window-buffer w)))
	(when (equal buf buffer)
	  (throw 'result w))))))

(defun ensime-point-at-bol (file line)
  (with-current-buffer (find-buffer-visiting file)
    (save-excursion
      (ensime-goto-line line)
      (point))))

(defun ensime-goto-source-location (pos &optional where)
  "Move to the source location POS. Don't open
 a new window or buffer if file is open and visible already."
  (let* ((file (ensime-pos-effective-file pos))
	 (file-visible-window (ensime-window-showing-file file)))

    (when (not file-visible-window)
      (ensime-find-file-from-pos pos where)
      (setq file-visible-window
	    (ensime-window-showing-file file)))

    (with-current-buffer (window-buffer file-visible-window)
      (let ((pt (cond
                 ((integerp (ensime-pos-offset pos))
                  (ensime-internalize-offset (ensime-pos-offset pos)))
                 ((integerp (ensime-pos-line pos))
                  (ensime-point-at-bol file (ensime-pos-line pos)))
                 (t 0))))
	(goto-char pt)
        (set-window-point file-visible-window pt)))))

(defun ensime-find-file-from-pos (pos other-window-p)
  (let* ((archive (ensime-pos-archive pos))
         (entry (ensime-pos-file pos))
         (effective-file (ensime-pos-effective-file pos))
         (existing-buffer (get-file-buffer effective-file)))
    (when archive
      (if existing-buffer
          (block nil
            (if other-window-p
                (switch-to-buffer-other-window existing-buffer)
              (switch-to-buffer existing-buffer))
            (return))
        (with-temp-buffer
          (archive-zip-extract archive entry)
          (make-directory (file-name-directory effective-file) t)
          (let ((backup-inhibited t))
            (write-file effective-file)))))

    (if other-window-p
        (find-file-other-window effective-file)
      (find-file effective-file))

    (when (ensime-path-includes-dir-p effective-file (ensime-source-jars-dir))
      (with-current-buffer (get-file-buffer effective-file)
        (setq buffer-read-only t)))))

;; Compilation result interface

(defvar ensime-compile-result-buffer-name "*ENSIME-Compilation-Result*")

(defvar ensime-compile-result-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") 'ensime-show-all-errors-and-warnings)
    (define-key map (kbd "TAB") 'forward-button)
    (define-key map (kbd "<backtab>") 'backward-button)
    (define-key map (kbd "M-n") 'forward-button)
    (define-key map (kbd "M-p") 'backward-button)
    map)
  "Key bindings for the build result popup.")

(defface ensime-compile-errline
  '((t (:inherit compilation-error)))
  "Face used for marking the line on which an error occurs."
  :group 'ensime-ui)

(defface ensime-compile-warnline
  '((t (:inherit compilation-warning)))
  "Face used for marking the line on which an warning occurs."
  :group 'ensime-ui)

(defun ensime-show-compile-result-buffer (notes-in)
  "Show a popup listing the results of the last build."

  (ensime-with-popup-buffer
   (ensime-compile-result-buffer-name t t)
   (use-local-map ensime-compile-result-map)
   (ensime-insert-with-face
    "Latest Compilation Results (q to quit, g to refresh, TAB to jump to next error)"
    'font-lock-constant-face)
   (if (null notes-in)
       (insert "\n0 errors, 0 warnings.")
     (save-excursion

       ;; Group notes by their file and sort by
       ;; position in the buffer.
       (let ((notes-by-file (make-hash-table :test 'equal)))
	 (dolist (note notes-in)
	   (let* ((f (ensime-note-file note))
		  (existing (gethash f notes-by-file)))
	     (puthash f (cons note existing) notes-by-file)))
	 (maphash (lambda (file-heading notes-set)
		    (let ((notes (sort (copy-list notes-set)
				       (lambda (a b) (< (ensime-note-beg a)
							(ensime-note-beg b))))))

		      ;; Output file heading
		      (ensime-insert-with-face
		       (concat "\n" file-heading "\n")
		       'font-lock-comment-face)

		      ;; Output the notes
		      (dolist (note notes)
			(destructuring-bind
			    (&key severity msg beg
				  end line col file &allow-other-keys) note
			  (let ((face (case severity
					(error 'ensime-compile-errline)
					(warn 'ensime-compile-warnline)
					(info font-lock-string-face)
					(otherwise font-lock-comment-face)))
				(header (case severity
					  (error "ERROR")
					  (warn "WARNING")
					  (info "INFO")
					  (otherwise "MISC")))
				(p (point)))
			    (insert (format "%s: %s : line %s"
					    header msg line))
			    (ensime-make-code-link p (point) file beg face)))
			(insert "\n"))))
		  notes-by-file)))
     (forward-button 1))))


;; Compilation on request

(defun ensime-typecheck-current-file (&optional without-saving)
  "Send a request for re-typecheck of current buffer to all ENSIME servers
 managing projects that contains the current buffer. By default, the buffer
 is saved first if it has unwritten modifications. With a prefix argument,
 the buffer isn't saved, instead the contents of the buffer is sent to the
 typechecker."
  (interactive "P")

  (when (and (not without-saving) (buffer-modified-p))
    (ensime-write-buffer nil t))

  ;; Send the reload request to all servers that might be interested.
  (dolist (con (ensime-connections-for-source-file buffer-file-name t))
    (setf (ensime-last-typecheck-run-time con) (float-time))
    (let ((ensime-dispatching-connection con))
      (if without-saving
          (save-restriction
            (widen)
            (ensime-rpc-async-typecheck-file-with-contents
             buffer-file-name
             (ensime-get-buffer-as-string)
             'identity))
        (progn
          (ensime-rpc-async-typecheck-file buffer-file-name 'identity))))))

(defun ensime-reload-open-files ()
  "Make the ENSIME server forget about all files ; reload .class files
in the project's path ;  then reload only the Scala files that are
currently open in emacs."
  (interactive)
  (message "Unloading all files...")
  (ensime-rpc-unload-all)
  (message "Reloading open files...")
  (setf (ensime-last-typecheck-run-time (ensime-connection)) (float-time))
  (let ((files (mapcar #'buffer-file-name
                       (ensime-connection-visiting-buffers (ensime-connection)))))
    (ensime-rpc-async-typecheck-files files 'identity)))

(defun ensime-typecheck-all ()
  "Send a request for re-typecheck of whole project to the ENSIME server.
   Current file is saved if it has unwritten modifications."
  (interactive)
  (message "Checking entire project...")
  (if (buffer-modified-p) (ensime-write-buffer nil t))
  (setf (ensime-awaiting-full-typecheck (ensime-connection)) t)
  (setf (ensime-last-typecheck-run-time (ensime-connection)) (float-time))
  (ensime-rpc-async-typecheck-all 'identity))

(defun ensime-show-all-errors-and-warnings ()
  "Show a summary of all compilation notes."
  (interactive)
  (let ((notes
         (append (ensime-java-compiler-notes (ensime-connection))
                 (ensime-scala-compiler-notes (ensime-connection)))))
    (ensime-show-compile-result-buffer notes)))

(defun ensime-sym-at-point (&optional point)
  "Return information about the symbol at point, using the an RPC request.
 If not looking at a symbol, return nil."
  (save-excursion
    (goto-char (or point (point)))
    (let* ((info (ensime-rpc-symbol-at-point))
           (pos (ensime-symbol-decl-pos info)))
      (if (null pos) (ensime-local-sym-at-point point)
        (let ((start (ensime-pos-offset pos))
              (name (plist-get info :local-name)))
          (setq start (ensime-internalize-offset start))
          (list :start start
                :end (+ start (string-width name))
                :name name))))))

(defun ensime-local-sym-at-point (&optional point)
  "Return information about the symbol at point. If not looking at a
 symbol, return nil."
  (save-excursion
    (goto-char (or point (point)))
    (let ((start nil)
          (end nil))
      (when (thing-at-point 'symbol)
        (save-excursion
          (search-backward-regexp "\\W" nil t)
          (setq start (+ (point) 1)))
        (save-excursion
          (search-forward-regexp "\\W" nil t)
          (setq end (- (point) 1)))
        (list :start start
              :end end
              :name (buffer-substring-no-properties start end))))))

(defun ensime-insert-import (qualified-name)
  "A simple, hacky import insertion."
  (save-excursion

    (let ((insertion-range (point))
          (starting-point (point)))
      (unless
          (search-backward-regexp "^\\s-*package\\s-" nil t)
        (goto-char (point-min)))
      (search-forward-regexp "^\\s-*import\\s-" insertion-range t)
      (goto-char (point-at-bol))

      (cond
       ;; No imports yet
       ((looking-at "^\\s-*package\\s-")
        (goto-char (point-at-eol))
        (newline)
        (newline))

       ;; Found import block, insert alphabetically
       ((looking-at "^\\s-*import\\s-")
        (unless (equal (point) (point-min)) (backward-char))
        (while (progn
                 (if (looking-at "[\n\t ]*import\\s-\\(.+\\)\n")
                     (let ((imported-name (match-string 1)))
                       (string< imported-name qualified-name))))
          (search-forward-regexp "^\\s-*import\\s-" insertion-range t)
          (goto-char (point-at-eol)))
        (if (equal (point) (point-max)) (newline) (forward-char 1)))

       ;; Neither import nor package: stay at beginning of buffer
       (t
        (unless (looking-at "^\s*$")
          (newline)
          (backward-char 1))))

      (when (>= (point) starting-point)
        (goto-char starting-point)
        (goto-char (point-at-bol)))
      (save-excursion
        (insert (format (cond ((ensime-visiting-scala-file-p) "import %s\n")
                              ((ensime-visiting-java-file-p) "import %s;\n"))
                        qualified-name)))
      (indent-region (point-at-bol) (point-at-eol)))))

(defun ensime-import-type-at-point (&optional non-interactive)
  "Suggest possible imports of the qualified name at point.
 If user selects and import, add it to the import list."
  (interactive)
  (let* ((sym (ensime-local-sym-at-point))
	 (name (plist-get sym :name))
	 (name-start (plist-get sym :start))
	 (name-end (plist-get sym :end))
	 (suggestions (ensime-rpc-import-suggestions-at-point (list name) 10)))
    (when suggestions
      (let* ((names (mapcar
		     (lambda (s)
		       (propertize (plist-get s :name)
				   'local-name
				   (plist-get s :local-name)))
		     (apply 'append suggestions)))
	     (selected-name
	      (if non-interactive (car names)
		(popup-menu*
		 names :point (point)))))
	(when selected-name
	  (save-excursion
	    (when (and (not (equal selected-name name))
                       name-start name-end)
	      (goto-char name-start)
	      (delete-char (- name-end name-start))
	      (insert (ensime-short-local-name
                       (get-text-property
                        0 'local-name selected-name))))
	    (let ((qual-name
		   (ensime-strip-dollar-signs
		    (ensime-kill-txt-props selected-name))))
	      (ensime-insert-import qual-name)
	      (ensime-typecheck-current-file t))))))))

;; Source Formatting

(defun ensime-format-source ()
  "Format the source in the current buffer using the Scalariform
 formatting library."
  (interactive)
  (if (version< (ensime-protocol-version) "0.8.11")
      (ensime-with-buffer-written-to-tmp
       (file)
       (message "Formatting...")
       (ensime-rpc-async-format-files
        (list file)
        `(lambda (result)
           (ensime-revert-visited-files (list (list ,buffer-file-name ,file)) t))))
    (let ((formatted (ensime-rpc-format-buffer)))
      (when formatted
        (when (eq 1 (coding-system-eol-type buffer-file-coding-system))
          (setq formatted (replace-regexp-in-string "\r$" "" formatted)))
        (let ((pt (point)))
          (erase-buffer)
          (insert formatted)
          (goto-char pt))))))

(defun ensime-revert-visited-files (files &optional typecheck)
  "files is a list of buffer-file-names to revert or lists of the form
 (visited-file-name disk-file-name) where buffer visiting visited-file-name
 will be reverted to the state of disk-file-name."
  (let ((pt (point)))
    (save-excursion
      (dolist (f files)
	(let* ((dest (cond ((stringp f) f)
			   ((listp f) (car f))))
	       (src (cond ((stringp f) f)
			  ((listp f) (cadr f)))))
	  (when-let (buf (find-buffer-visiting dest))
                    (with-current-buffer buf
		      (insert-file-contents src nil nil nil t)
		      ;; Rather than pass t to 'visit' the file by way of
		      ;; insert-file-contents, we manually clear the
		      ;; modification flags. This way the buffer-file-name
		      ;; is untouched.
		      (when (equal dest src)
			(clear-visited-file-modtime)
			(set-buffer-modified-p nil))
                      (when typecheck
                        (ensime-typecheck-current-file)))))))
    (goto-char pt)))

;; Expand selection

(defvar ensime-selection-overlay nil)
(defvar ensime-selection-stack nil)

(defun ensime-set-selection-overlay (start end)
  "Set the current selection overlay, creating if needed."
  (ensime-clear-selection-overlay)
  (setq ensime-selection-overlay
	(ensime-make-overlay start end nil 'region nil)))

(defun ensime-clear-selection-overlay ()
  (when (and ensime-selection-overlay
	     (overlayp ensime-selection-overlay))
    (delete-overlay ensime-selection-overlay)))

(defun ensime-expand-selection-command ()
  "Expand selection to the next widest syntactic context."
  (interactive)
  (unwind-protect
      (let* ((continue t)
	     (ensime-selection-stack (list (list (point) (point))))
	     (expand-again-key 46)
	     (contract-key 44))
	(ensime-expand-selection (point) (point))
	(while continue
	  (message "(Type . to expand again. Type , to contract.)")
	  (let ((evt (read-event)))
	    (cond

	     ((equal expand-again-key evt)
	      (progn
		(clear-this-command-keys t)
		(ensime-expand-selection (mark) (point))
		(setq last-input-event nil)))

	     ((equal contract-key evt)
	      (progn
		(clear-this-command-keys t)
		(ensime-contract-selection)
		(setq last-input-event nil)))
	     (t
	      (setq continue nil)))))
	(when last-input-event
	  (clear-this-command-keys t)
	  (setq unread-command-events (list last-input-event))))

    (ensime-clear-selection-overlay)))

(defun ensime-set-selection (start end)
  "Helper to set selection state."
  (goto-char start)
  (command-execute 'set-mark-command)
  (goto-char end)
  (setq deactivate-mark nil)
  (ensime-set-selection-overlay start end))

(defun ensime-expand-selection (start end)
  "Expand selection to the next widest syntactic context."
  (ensime-with-buffer-written-to-tmp
   (file)
   (let* ((range (ensime-rpc-expand-selection
		  file start end))
	  (start (plist-get range :start))
	  (end (plist-get range :end)))
     (ensime-set-selection start end)
     (push (list start end) ensime-selection-stack))))

(defun ensime-contract-selection ()
  "Contract to previous syntactic context."
  (pop ensime-selection-stack)
  (let ((range (car ensime-selection-stack)))
    (when range
      (let ((start (car range))
	    (end (cadr range)))
	(ensime-set-selection start end)))))

(defun ensime-inspect-bytecode ()
  "Show the bytecode for the current method."
  (interactive)
  (let ((bc (ensime-rpc-method-bytecode buffer-file-name (ensime-current-line))))
    (if (not bc)
	(message "Could not find bytecode.")
      (progn
	(ensime-ui-show-nav-buffer "*ensime-method-bytecode-buffer*" bc t)))))

(defvar ensime-ui-method-bytecode-handler
  (list
   :init (lambda (info)
	   (ensime-ui-insert-method-bytecode info))
   :update (lambda (info))
   :help-text "Press q to quit."
   :writable nil
   :keymap `()))

(defun ensime-ui-insert-method-bytecode (val)
  (destructuring-bind
      (&key class-name name bytecode &allow-other-keys) val
    (insert class-name)
    (insert "\n")
    (insert name)
    (insert "\n\n")
    (dolist (op bytecode)
      (ensime-insert-with-face (car op) 'font-lock-constant-face)
      (insert " ")
      (ensime-insert-with-face (cadr op) 'font-lock-variable-name-face)
      (insert "\n"))))

;; Uses UI

(defvar ensime-uses-buffer-name "*Uses*")

(defvar ensime-uses-buffer-map
  (let ((map (make-sparse-keymap)))
    (define-key map [?\t] 'forward-button)
    (define-key map (kbd "M-n") 'forward-button)
    (define-key map (kbd "M-p") 'backward-button)
    map)
  "Key bindings for the uses popup.")

(defun ensime-show-uses-of-symbol-at-point ()
  "Display a hyperlinked list of the source locations
 where the symbol under point is referenced."
  (interactive)
  (let ((uses (ensime-rpc-uses-of-symbol-at-point)))
    (ensime-with-popup-buffer
     (ensime-uses-buffer-name t t)
     (use-local-map ensime-uses-buffer-map)


     (ensime-insert-with-face
      "TAB to advance to next use, q to quit"
      'font-lock-constant-face)
     (insert "\n\n\n")

     (dolist (pos uses)
       (let* ((file (ensime-pos-file pos))
              (pos-internal-offset (ensime-internalize-offset-for-file
                                    file
                                    (ensime-pos-offset pos)))

	      (range-start (- pos-internal-offset 80))
	      (range-end (+ pos-internal-offset 80))
	      (result (ensime-extract-file-chunk
		       file range-start range-end))
	      (chunk-text (plist-get result :text))
	      (chunk-start (plist-get result :chunk-start))
	      (chunk-start-line (plist-get result :chunk-start-line)))

	 (ensime-insert-with-face file 'font-lock-comment-face)
	 (ensime-insert-with-face
	  (format "\n------------------- @line %s -----------------------\n"
		  chunk-start-line)
	  'font-lock-comment-face)

	 (let ((p (point)))

	   ;; Insert the summary chunk
	   (insert chunk-text)

	   ;; Highlight the occurances
	   (let* ((external-from (plist-get pos :start))
                  (from (ensime-internalize-offset-for-file
                         file
                         (plist-get pos :start)))
		  (to (ensime-internalize-offset-for-file
                       file
                       (plist-get pos :end)))
		  (buffer-from (+ p (- from chunk-start)))
		  (buffer-to (+ p (- to chunk-start))))
	     (ensime-make-code-link
	      buffer-from buffer-to file external-from)))

	 (insert "\n\n\n")))
     (goto-char (point-min))
     (when uses (forward-button 1)))
    (ensime-event-sig :references-buffer-shown)))

(provide 'ensime-editor)

;; Local Variables:
;; no-byte-compile: t
;; End:
