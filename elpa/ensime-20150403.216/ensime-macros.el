;;; ensime-macros.el
;;
;;;; License
;;
;;     Copyright (C) 2010 Aemon Cannon
;;
;;     This program is free software; you can redistribute it and/or
;;     modify it under the terms of the GNU General Public License as
;;     published by the Free Software Foundation; either version 2 of
;;     the License, or (at your option) any later version.
;;
;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public
;;     License along with this program; if not, write to the Free
;;     Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
;;     MA 02111-1307, USA.

(eval-when-compile (require 'cl))

(defmacro ensime-with-conn-interactive (conn-sym &rest body)
  "Surround body forms with a check to see if we're connected.
If not, message the user."
  `(let* ((,conn-sym (or (ensime-connection-or-nil)
			 (ensime-prompt-for-connection))))
     (if conn
	 (progn ,@body)
       (message
	"This command requires a connection to an ENSIME server."))))

(defmacro* when-let ((var value) &rest body)
  "Evaluate VALUE, if the result is non-nil bind it to VAR and eval BODY.

\(fn (VAR VALUE) &rest BODY)"
  `(let ((,var ,value))
     (when ,var ,@body)))

(defmacro* ensime-with-popup-buffer ((name &optional connection select major-mode-fn)
				     &body body)
  "Similar to `with-output-to-temp-buffer'.
Bind standard-output and initialize some buffer-local variables.
Restore window configuration when closed.

NAME is the name of the buffer to be created.
CONNECTION is the value for `ensime-buffer-connection'.
If nil, no explicit connection is associated with
the buffer.  If t, the current connection is taken.
SELECT determines whether the new window is selected.
MAJOR-MODE-FN, if non-nil, is executed immediately after the new
buffer is created, for example to set the major mode.
"
  `(let* ((vars% (list ,(if (eq connection t) '(ensime-connection) connection)))
	  (standard-output (ensime-make-popup-buffer ,name vars% ,major-mode-fn)))
     (with-current-buffer standard-output
       (prog1
	   (progn
	     ,@body)
	 (assert (eq (current-buffer) standard-output))
	 (setq buffer-read-only t)
	 (set-window-point (ensime-display-popup-buffer ,(or select 'nil))
			   (point))))))

(defmacro ensime-assert-buffer-saved-interactive (&rest body)
  "Offer to save buffer if buffer is modified. Execute body only if
buffer is saved."
  `(if (buffer-modified-p)
       (if (y-or-n-p "Buffer must be saved to continue. Save now? ")
	   (progn
	     (ensime-save-buffer-no-hooks)
	     ,@body))
     (progn
       ,@body)))

(defmacro* ensime-with-connection-buffer ((&optional process) &rest body)
  "Execute BODY in the process-buffer of PROCESS.
If PROCESS is not specified, `ensime-connection' is used.

\(fn (&optional PROCESS) &body BODY))"
  `(with-current-buffer
       (process-buffer (or ,process (ensime-connection)
			   (error "No connection")))
     ,@body))

(defmacro* ensime-with-inspector-buffer ((name object &optional select)
					 &body body)
  "Extend the standard popup buffer with inspector-specific bindings."
  `(ensime-with-popup-buffer
    (,name t ,select 'ensime-inspector-mode)

    (let ((conn ensime-buffer-connection))
      (setq ensime-buffer-connection conn))

    (when (not ensime-inspector-paging-in-progress)

      ;; Clamp the history cursor
      (setq ensime-inspector-history-cursor
	    (max 0 ensime-inspector-history-cursor))
      (setq ensime-inspector-history-cursor
	    (min (- (length ensime-inspector-history) 1)
		 ensime-inspector-history-cursor))

      ;; Remove all elements preceding the cursor (the 'redo' history)
      (setq ensime-inspector-history
	    (subseq ensime-inspector-history
		    ensime-inspector-history-cursor))

      ;; Add the new history item
      (push ,object ensime-inspector-history)

      ;; Set cursor to point to the new item
      (setq ensime-inspector-history-cursor 0)

      )
    ,@body
    ))

(defmacro destructure-case (value &rest patterns)
  "Dispatch VALUE to one of PATTERNS.
A cross between `case' and `destructuring-bind'.
The pattern syntax is:
  ((HEAD . ARGS) . BODY)
The list of patterns is searched for a HEAD `eq' to the car of
VALUE. If one is found, the BODY is executed with ARGS bound to the
corresponding values in the CDR of VALUE."
  (let ((operator (gensym "op-"))
	(operands (gensym "rand-"))
	(tmp (gensym "tmp-")))
    `(let* ((,tmp ,value)
	    (,operator (car ,tmp))
	    (,operands (cdr ,tmp)))
       (case ,operator
	 ,@(mapcar (lambda (clause)
		     (if (eq (car clause) t)
			 `(t ,@(cdr clause))
		       (destructuring-bind ((op &rest rands) &rest body) clause
			 `(,op (destructuring-bind ,rands ,operands
				 . ,body)))))
		   patterns)
	 ,@(if (eq (caar (last patterns)) t)
	       '()
	     `((t (error "Elisp destructure-case failed: %S" ,tmp))))))))


(defmacro ensime-define-keys (keymap &rest key-command)
  "Define keys in KEYMAP. Each KEY-COMMAND is a list of (KEY COMMAND)."
  `(progn . ,(mapcar (lambda (k-c) `(define-key ,keymap . ,k-c))
		     key-command)))


(defmacro* with-struct ((conc-name &rest slots) struct &body body)
  "Like with-slots but works only for structs.
\(fn (CONC-NAME &rest SLOTS) STRUCT &body BODY)"
  (flet ((reader (slot) (intern (concat (symbol-name conc-name)
					(symbol-name slot)))))
    (let ((struct-var (gensym "struct")))
      `(let ((,struct-var ,struct))
	 (symbol-macrolet
	     ,(mapcar (lambda (slot)
			(etypecase slot
			  (symbol `(,slot (,(reader slot) ,struct-var)))
			  (cons `(,(first slot) (,(reader (second slot))
						 ,struct-var)))))
		      slots)
	   . ,body)))))


(defvar ensime-qualified-type-regexp
  "^\\(?:object \\)?\\(\\(?:[a-z0-9_]+\\.\\)*\\)\\(?:\\([^\\.]+?\\)\\$\\)?\\(\\$\\$anon\\|[^\\.$]+\\$?\\)$"
  "Match strings of form pack.pack1.pack2.Types$Type or pack.pack1.pack2.Type")
(defmacro* ensime-with-name-parts (str (path outer-type-name name) &rest body)
  "Evaluate BODY with path bound to the dot-separated path of
 this type-name, and name bound to the final type name."
  (let ((tmp (gensym)))
    `(let ((matchedp (integerp (string-match
				ensime-qualified-type-regexp
				,str))))
       (let* ((,tmp (if matchedp (match-string 1 ,str) nil))
	      (,path (if (> (length ,tmp) 0)
			 (substring ,tmp 0 (- (length ,tmp) 1)) ,tmp))
	      (,outer-type-name (if matchedp (match-string 2 ,str) nil))
	      (,name (if matchedp (match-string 3 ,str) ,str)))
	 ,@body))))

(defvar ensime-qualified-path-and-name-regexp
  "^\\(\\(?:[a-z0-9_]+\\.\\)*\\)\\([^\\.]*\\)$")
(defmacro* ensime-with-path-and-name (str (path name) &rest body)
  "Evaluate body with path bound to all sections up to the
 last, concatenated, and name bound to the last section."
  (let ((tmp (gensym)))
    `(let ((matchedp (integerp (string-match
				ensime-qualified-path-and-name-regexp
				,str))))
       (let* ((,tmp (if matchedp (match-string 1 ,str) nil))
	      (,path (if (> (length ,tmp) 0)
			 (substring ,tmp 0 (- (length ,tmp) 1)) ,tmp))
	      (,name (if matchedp (match-string 2 ,str) nil)))
	 ,@body))))


(provide 'ensime-macros)

;; Local Variables:
;; no-byte-compile: t
;; End:
