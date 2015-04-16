;;; ensime-client.el --- Talk to the server

;;;; Connections
;;;
;;; "Connections" are the high-level Emacs<->ENSIME-Server networking concept.
;;;
;;; Emacs has a connection to each ENSIME server process that it's interacting
;;; with. Typically there would only be one, but a user can choose to
;;; connect to many servers simultaneously.
;;;
;;; A connection corresponds to an elisp process object. Each connection has an
;;; corresponding buffer, and 'connection vars' are implemented as
;;; buffer-local vars of that buffer.
;;;
;;; One connection is "current" at any given time. This is:
;;;   `ensime-dispatching-connection' if dynamically bound, or
;;;   `ensime-buffer-connection' if this is set buffer-local,
;;;   or the value of `(ensime-owning-connection-for-source-file buffer-file-name)'
;;;   otherwise.
;;;
;;; Generally one accesses the active connection with (ensime-connection), which
;;; will try each of the above in turn.
;;;
;;; When a command creates a new buffer it will set
;;; `ensime-buffer-connection' so that commands in the new buffer will
;;; use the connection that the buffer originated from. For example,
;;; the apropos command creates the *Apropos* buffer and any command
;;; in that buffer (e.g. `M-.') will go to the same Lisp that did the
;;; apropos search. REPL buffers are similarly tied to their
;;; respective connections.
;;;
;;; When Emacs is dispatching some network message that arrived from a
;;; connection it will dynamically bind `ensime-dispatching-connection'
;;; so that the event will be processed in the context of that
;;; connection.
;;;
;;; This is mostly transparent. The user should be aware that he can
;;; set the default connection to pick which Server handles commands in
;;; ensime-mode source buffers, and ensime hackers should be aware that
;;; they can tie a buffer to a specific connection. The rest takes
;;; care of itself.


(defmacro ensime-def-connection-var (varname &rest initial-value-and-doc)
  "Define a connection-local variable.
The value of the variable can be read by calling the function of the
same name (it must not be accessed directly). The accessor function is
setf-able.

The actual variable bindings are stored buffer-local in the
process-buffers of connections. The accessor function refers to
the binding for `ensime-connection'."
  (let ((real-var (intern (format "%s:connlocal" varname)))
        (store-var (gensym)))
    `(progn
       ;; Variable
       (make-variable-buffer-local
       (defvar ,real-var ,@initial-value-and-doc))
       ;; Accessor
       (defun ,varname (&optional process)
         (ensime-with-connection-buffer (process) ,real-var))
       ;; Setf
       (defsetf ,varname (&optional process) (store)
         `(let ((,',store-var ,store))
            (ensime-with-connection-buffer (,process)
              (setq ,',real-var ,',store-var)
              ,',store-var)))
       '(\, varname))))

(put 'ensime-def-connection-var 'lisp-indent-function 2)
(put 'ensime-indulge-pretty-colors 'ensime-def-connection-var t)

(ensime-def-connection-var ensime-connection-number nil
  "Serial number of a connection.
Bound in the connection's process-buffer.")

(ensime-def-connection-var ensime-server-features '()
  "The symbol-names of Lisp's *FEATURES*.
This is automatically synchronized from Lisp.")

(ensime-def-connection-var ensime-pid nil
  "The process id of the Lisp process.")

(ensime-def-connection-var ensime-protocol-version nil
  "The protocol version used on the connection.")

(ensime-def-connection-var ensime-server-implementation-version nil
  "The implementation type of the Lisp process.")

(ensime-def-connection-var ensime-server-implementation-name nil
  "The short name for the Lisp implementation.")

(ensime-def-connection-var ensime-connection-name nil
  "The short name for connection.")

(ensime-def-connection-var ensime-config nil
  "The project configuration corresponding to this connection.")

(ensime-def-connection-var ensime-analyzer-ready nil
  "Whether the analyzer has finished its initial run.")

(ensime-def-connection-var ensime-scala-compiler-notes nil
  "Warnings, Errors, and other notes produced by the analyzer.")

(ensime-def-connection-var ensime-java-compiler-notes nil
  "Warnings, Errors, and other notes produced by the analyzer.")

(ensime-def-connection-var ensime-awaiting-full-typecheck nil
  "Should we show the errors and warnings report on next full-typecheck event?")

(ensime-def-connection-var ensime-num-errors 0
  "Current number of errors in project.")

(ensime-def-connection-var ensime-num-warnings 0
  "Current number of warnings in project.")

(ensime-def-connection-var ensime-last-typecheck-run-time 0
  "Last time `ensime-typecheck-current-file' was run.")

(ensime-def-connection-var ensime-rex-continuations '()
  "List of (ID . FUNCTION) continuations waiting for RPC results.")

(ensime-def-connection-var ensime-continuation-counter 0
  "Continuation serial number counter.")



(defvar ensime-dispatching-connection nil
  "Network process currently executing.
This is dynamically bound while handling messages from Lisp; it
overrides `ensime-buffer-connection'.")

(defvar-local ensime-buffer-connection nil
  "Network connection to use in the current buffer.")

(defvar ensime-connection-counter 0
  "The number of ENSIME connections made. For generating serial numbers.")

(defun ensime-connection-or-nil ()
  "Return the connection to use for ENSIME interaction in the current buffer.
 Return nil if there's no connection.
   * In most code we prefer (ensime-connection), which raises an error if
     the connection is not present.
   * This function is ambiguous if there's more than one ensime connection for
     the current source file (shouldn't really happen in practice)."
  (or (ensime-conn-if-alive ensime-dispatching-connection)
      (ensime-conn-if-alive ensime-buffer-connection)
      (when-let (conn (ensime-conn-if-alive
		       (ensime-owning-connection-for-source-file
			buffer-file-name)))
	  ;; Cache the connection so lookup is fast next time.
	  (setq ensime-buffer-connection conn)
	  conn)))

(defun ensime-proc-if-alive (proc)
  "Returns proc if proc's buffer is alive and proc has not exited,
 otherwise nil."
  (when (and proc
	     (buffer-live-p (process-buffer proc))
	     (let ((status (process-status proc)))
	       (and (not (eq status 'exit))
		    (not (null status)))))
    proc))

(defun ensime-conn-if-alive (conn)
  "Returns connection if connection is open."
  (when (and conn (eq 'open (process-status conn)))
    (ensime-proc-if-alive conn)))

(defun ensime-connected-p (&optional conn)
  "Return t if there is a valid, active connection."
  (let ((conn (or conn (ensime-connection-or-nil))))
    (and conn
	 (buffer-live-p (process-buffer conn))
	 (eq (process-status conn) 'open))))

(defun ensime-connection ()
  "Return the connection to use for Lisp interaction.
 Signal an error if there's no connection."
  (let ((conn (ensime-connection-or-nil)))
    (cond ((not conn)
           (or (ensime-auto-connect)
               (error "Not connected. M-x ensime to connect")))
          ((not (eq (process-status conn) 'open))
           (error "Connection closed."))
          (t conn))))


(defun ensime-connection-visiting-buffers (conn)
  "Return a list of all buffers associated with the given
 connection."
  (let ((result '()))
    (dolist (buf (buffer-list))
      (let ((f (buffer-file-name buf)))
        (when (and f (ensime-source-file-belongs-to-connection-p f conn))
          (setq result (cons buf result)))))
    result))

(defun ensime-source-file-belongs-to-connection-p (file-in conn)
  "Does the given source file belong to the given connection(project)?"
  (ensime-config-includes-source-file (ensime-config conn) file-in))

(defun ensime-connections-for-source-file (file-in &optional no-ref-sources)
  "Return the connections corresponding to projects that contain
 the given file in their source trees."
  (let ((result '()))
    (dolist (conn ensime-net-processes)
      (when-let (conn (ensime-conn-if-alive conn))
		(when (ensime-config-includes-source-file
		       (ensime-config conn) file-in no-ref-sources)
		  (setq result (cons conn result)))))
        result))

(defvar-local ensime--buffer-unrelated-server-procs nil
  "An optimization: server processes known to not be associated with the current
 buffer.")
(defun ensime-owning-server-process-for-source-file (source-file)
  "Returns the first server process with a source-root that contains
  file-in."
  (when (-difference ensime-server-processes ensime--buffer-unrelated-server-procs)
    (let ((found (-find
		  (lambda (proc)
		    (when-let (good-proc (ensime-proc-if-alive proc))
			      (ensime-config-includes-source-file
			       (process-get good-proc :ensime-config) source-file)))
		  ensime-server-processes)))
      (if found found
	;; Otherwise remember the procs we've already checked.
	(setq ensime--buffer-unrelated-server-procs ensime-server-processes)
	nil
	))))

(defvar-local ensime--buffer-unrelated-connections nil
  "An optimization: connections known to not be associated with the current
 buffer.")
(defun ensime-owning-connection-for-source-file (source-file)
  "Returns the first connection process with a source-root that contains
  source-file."
  (when (-difference ensime-net-processes ensime--buffer-unrelated-connections)
    (let ((found (-find
		  (lambda (conn)
		    (when-let (good-conn (ensime-conn-if-alive conn))
			      (ensime-config-includes-source-file
			       (ensime-config good-conn) source-file)))
		  ensime-net-processes)))
      (if found found
	;; Otherwise remember the connections we've already checked.
	(setq ensime--buffer-unrelated-connections ensime-net-processes)
	nil
	))))

(defun ensime-interrupt-all-servers ()
  (-each ensime-server-processes
    (lambda (p) (ensime-interrupt-buffer-process (process-buffer p)))))

(defun ensime-interrupt-buffer-process (&optional buffer)
  "Send SIGINT to p if p is an active process."
  (when-let (proc (ensime-proc-if-alive
		   (get-buffer-process (or buffer (current-buffer)))))
	    (interrupt-process proc)))

(defun ensime-prompt-for-connection ()
  "Prompt the user to select a server connection. Used in situations where
 the active connection is ambiguous."
  (let* ((options
      (mapcar
       (lambda (p)
         (let* ((conf (ensime-config p))
            (root (plist-get conf :root-dir))
            (num (ensime-connection-number p)))
           `(,(format "%s#%s" root num) . ,p)))
       ensime-net-processes))
     (keys (mapcar (lambda (opt) (car opt)) options)))
    (let ((key (when keys
         (completing-read
          (concat "Which project to use? ("
              (mapconcat #'identity keys ", ")
              "): ")
          keys nil t (car keys)))))
      (cdr (assoc key options)))))


;; FIXME: should be called auto-start
(defcustom ensime-auto-connect 'never
  "Controls auto connection when information from lisp process is needed.
This doesn't mean it will connect right after Ensime is loaded."
  :group 'ensime-mode
  :type '(choice (const never)
         (const always)
         (const ask)))

(defun ensime-auto-connect ()
  (cond ((or (eq ensime-auto-connect 'always)
         (and (eq ensime-auto-connect 'ask)
          (y-or-n-p "No connection.  Start Ensime? ")))
     (save-window-excursion
       (ensime)
       (while (not (ensime-connection-or-nil))
         (sleep-for 1))
       (ensime-connection)))
    (t nil)))

(defun ensime-setup-connection (process)
  "Make a connection out of PROCESS."
  (let ((ensime-dispatching-connection process))

    (setf (ensime-protocol-version process) nil
          (ensime-pid process) nil
          (ensime-server-implementation-name process) nil
          (ensime-connection-name process) nil
          (ensime-analyzer-ready process) nil)

    ;; Initialize connection state in the process-buffer of PROC."

    ;; To make life simpler for the user: if this is the only open
    ;; connection then reset the connection counter.
    (when (equal ensime-net-processes (list process))
      (setq ensime-connection-counter 0))

    (ensime-with-connection-buffer
     () (setq ensime-buffer-connection process))

    (setf (ensime-connection-number process)
      (incf ensime-connection-counter))

    process))

(defun ensime-connect (host port)
  "Connect to a running Swank server. Return the connection."
  (interactive (list
        (read-from-minibuffer "Host: " "127.0.0.1")
        (read-from-minibuffer "Port: " (format "%d" ensime-default-server-port) nil t)))
  (when (and (interactive-p) ensime-net-processes
         (y-or-n-p "Close old connections first? "))
    (ensime-disconnect-all))
  (message "Connecting to Swank on port %S.." port)
  (let* ((process (ensime-net-connect host port))
         (ensime-dispatching-connection process))
    (ensime-setup-connection process)))


(defun ensime-handle-connection-info (connection info)
  "Initialize CONNECTION with INFO received from Lisp."
  (ensime-event-sig :connected info)
  (let ((ensime-dispatching-connection connection))
    (destructuring-bind (&key pid server-implementation version
                              &allow-other-keys) info
      (setf (ensime-pid) pid)
      (setf (ensime-protocol-version) version)
      (destructuring-bind (&key name) server-implementation
        (setf (ensime-server-implementation-name) name
              (ensime-connection-name) (ensime-generate-connection-name name)))
      ))

  (run-hooks 'ensime-connected-hook)
  (message "Connected to ENSIME speaking protocol %s, please wait while the project is loaded."
	   (ensime-protocol-version))
  (ensime-init-project connection))

;;;;; Connection listing

(define-derived-mode ensime-connection-list-mode fundamental-mode
  "Ensime-Connections"
  "ENSIME Connection List Mode.

\\{ensime-connection-list-mode-map}
\\{ensime-popup-buffer-map}"
  (when ensime-truncate-lines
    (set (make-local-variable 'truncate-lines) t)))

(ensime-define-keys ensime-connection-list-mode-map
		    ("g"         'ensime-update-connection-list)
		    ((kbd "C-k") 'ensime-quit-connection-at-point)
		    ("R"         'ensime-restart-connection-at-point))

(defun ensime-connection-at-point ()
  (or (get-text-property (point) 'ensime-connection)
      (error "No connection at point")))

(defun ensime-quit-connection-at-point (connection)
  (interactive (list (ensime-connection-at-point)))
  (ensime-quit-connection connection)
  (ensime-update-connection-list))

(defun ensime-quit-connection (connection)
  (ensime-rpc-shutdown-server)
  (let ((end (time-add (current-time) (seconds-to-time 3))))
    (while (memq connection ensime-net-processes)
      (when (time-less-p end (current-time))
	(message "Quit timeout expired.  Disconnecting.")
	(delete-process connection))
      (sit-for 0 100))
    ))

(defun ensime-restart-connection-at-point (connection)
  (interactive (list (ensime-connection-at-point)))
  (let ((ensime-dispatching-connection connection))
    (ensime-restart-inferior-lisp)))


(defvar ensime-connections-buffer-name "*ENSIME Connections*")

(defun ensime-list-connections ()
  "Display a list of all connections."
  (interactive)
  (ensime-with-popup-buffer (ensime-connections-buffer-name
                             nil nil 'ensime-connection-list-mode)
    (ensime-draw-connection-list)))

(defun ensime-update-connection-list ()
  "Display a list of all connections."
  (interactive)
  (let ((pos (point))
	(inhibit-read-only t))
    (erase-buffer)
    (ensime-draw-connection-list)
    (goto-char pos)))

(defun ensime-draw-connection-list ()
  (let ((default-pos nil)
	(fstring "%s%2s  %-10s  %-17s  %-7s\n"))
    (insert (format fstring " " "Nr" "Name" "Port" "Pid")
	    (format fstring " " "--" "----" "----" "---"))
    (dolist (p (reverse ensime-net-processes))
      (ensime-insert-propertized
       (list 'ensime-connection p)
       (format fstring
	       " "
	       (ensime-connection-number p)
	       (ensime-connection-name p)
	       (or (process-id p) (process-contact p))
	       (ensime-pid p))))))



(defun ensime-generate-connection-name (server-name)
  (loop for i from 1
	for name = server-name then (format "%s<%d>" server-name i)
	while (find name ensime-net-processes
		    :key #'ensime-connection-name :test #'equal)
	finally (return name)))


;;;;; Commands on connections

(defun ensime-connection-close-hook (process)

  ;; TODO should this be per-connection?
  (ensime-clear-note-overlays))

(add-hook 'ensime-net-process-close-hooks 'ensime-connection-close-hook)

(defun ensime-disconnect ()
  "Close the current connection."
  (interactive)
  (ensime-net-close (ensime-connection)))

(defun ensime-disconnect-all ()
  "Disconnect all connections."
  (interactive)
  (mapc #'ensime-net-close ensime-net-processes))

(defun ensime-connection-port (connection)
  "Return the remote port number of CONNECTION."
  (if (featurep 'xemacs)
      (car (process-id connection))
    (cadr (process-contact connection))))

(defun ensime-set-config (connection config)
  (setf (ensime-config connection) config))

;;; Network protocol

(defvar ensime-net-processes nil
  "List of processes (sockets) connected to Lisps.")

(defvar ensime-server-processes nil
  "List of (active) ensime server processes spawned by emacs.")

(defvar ensime-net-process-close-hooks '()
  "List of functions called when a ensime network connection closes.
The functions are called with the process as their argument.")

(defun ensime-net-connect (host port)
  "Establish a connection with a CL."
  (let* ((inhibit-quit nil)
	 (proc (open-network-stream "ENSIME Scala" nil host port))
	 (buffer (ensime-make-net-buffer " *ensime-connection*")))
    (push proc ensime-net-processes)
    (set-process-buffer proc buffer)
    (set-process-filter proc 'ensime-net-filter)
    (set-process-sentinel proc 'ensime-net-sentinel)
    (ensime-set-query-on-exit-flag proc)

    ;; TODO make this smart like slime?
    (set-process-coding-system proc 'utf-8-unix 'utf-8-unix)

    proc))

(defun ensime-set-query-on-exit-flag (process)
  "Set PROCESS's query-on-exit-flag to `ensime-kill-without-query-p'."
  (when ensime-kill-without-query-p
    ;; avoid byte-compiler warnings
    (let ((fun (if (fboundp 'set-process-query-on-exit-flag)
		   'set-process-query-on-exit-flag
		 'process-kill-without-query)))
      (funcall fun process nil))))

(defun ensime-make-net-buffer (name)
  "Make a buffer suitable for a network process."
  (let ((buffer (generate-new-buffer name)))
    (with-current-buffer buffer
      (set-buffer-multibyte t)
      (buffer-disable-undo)
      (set (make-local-variable 'kill-buffer-query-functions) nil))
    buffer))

(defun ensime-net-send (sexp proc)
  "Send a SEXP to Lisp over the socket PROC. This is the lowest
 level of communication. The sexp will be read and interpreted
 by the Ensime Server."
  (let* ((msg (concat (ensime-prin1-to-string sexp) "\n"))
	 (string (concat (ensime-net-encode-length (length msg)) msg))
	 (coding-system (cdr (process-coding-system proc))))
    (ensime-log-event sexp)
    (process-send-string proc string)))

(defun ensime-net-close (process &optional debug)
  (setq ensime-net-processes (remove process ensime-net-processes))
  (set-process-sentinel process 'ignore)
  (set-process-filter process 'ignore)
  (delete-process process)
  (run-hook-with-args 'ensime-net-process-close-hooks process)
  ;; killing the buffer also closes the socket
  (kill-buffer (process-buffer process)))

(defun ensime-net-sentinel (process message)
  (message "Server connection closed unexpectedly: %s" message)
  (ensime-net-close process))

;;; Socket input is handled by `ensime-net-filter', which decodes any
;;; complete messages and hands them off to the event dispatcher.

(defun ensime-net-filter (process string)
  "Accept output from the socket and process all complete messages."
  (with-current-buffer (process-buffer process)
    (goto-char (point-max))
    (insert string))
  (ensime-process-available-input process))

(defun ensime-process-available-input (process)
  "Process all complete messages that have arrived from Lisp."
  (with-current-buffer (process-buffer process)
    (while (and
	    (buffer-live-p (process-buffer process))
	    (ensime-net-have-input-p))
      (let ((event (ensime-net-read-or-lose process))
	    (ok nil))
	(when ensime-log-events
	  (ensime-log-event event))
	(unwind-protect
	    (save-current-buffer
	      (ensime-dispatch-event event process)
	      (setq ok t))
	  (unless ok
	    (ensime-run-when-idle
	     'ensime-process-available-input process)))))))

(defun ensime-net-have-input-p ()
  "Return true if a complete message is available."
  (goto-char (point-min))
  (and (>= (ensime-buffer-size-in-bytes) 6)
       (>= (- (ensime-buffer-size-in-bytes) 6)
	   (ensime-net-decode-length))))

(defun ensime-buffer-size-in-bytes ()
  (- (position-bytes (point-max)) 1))

(defun ensime-run-when-idle (function &rest args)
  "Call FUNCTION as soon as Emacs is idle."
  (apply #'run-at-time
	 (if (featurep 'xemacs) itimer-short-interval 0)
	 nil function args))

(defun ensime-net-read-or-lose (process)
  (condition-case error
      (ensime-net-read)
    (error
     (debug 'error error)
     (ensime-net-close process)
     (error "net-read error: %S" error))))

(defun ensime-net-read ()
  "Read a message from the network buffer."
  (goto-char (point-min))
  (let* ((length (ensime-net-decode-length))
	 (start (+ 6 (point)))
	 (end (+ start length)))
    (assert (plusp length))
    (goto-char (byte-to-position start))
    (prog1 (read (current-buffer))
      (delete-region (- (byte-to-position start) 6)
		     (byte-to-position end)))
    ))


(defun ensime-net-decode-length ()
  "Read a 24-bit hex-encoded integer from buffer."
  (string-to-number (buffer-substring-no-properties (point) (+ (point) 6)) 16))

(defun ensime-net-encode-length (n)
  "Encode an integer into a 24-bit hex string."
  (format "%06x" n))

(defun ensime-prin1-to-string (sexp)
  "Like `prin1-to-string' but don't octal-escape non-ascii characters.
This is more compatible with the CL reader."
  (with-temp-buffer
    (let (print-escape-nonascii
	  print-escape-newlines
	  print-length
	  print-level)
      (prin1 sexp (current-buffer))
      (buffer-string))))



;;;;; Event logging to *ensime-events*
;;;
;;; The *ensime-events* buffer logs all protocol messages for debugging
;;; purposes. Optionally you can enable outline-mode in that buffer,
;;; which is convenient but slows things down significantly.

(defvar ensime-log-events nil
  "*Log protocol events to the *ensime-events* buffer.")

(defvar ensime-outline-mode-in-events-buffer nil
  "*Non-nil means use outline-mode in *ensime-events*.")

(defvar ensime-event-buffer-name "*ensime-events*"
  "The name of the ensime event buffer.")

(defun ensime-log-event (event)
  "Record the fact that EVENT occurred."
  (when ensime-log-events
    (with-current-buffer (ensime-events-buffer)
      ;; trim?
      (when (> (buffer-size) 100000)
	(goto-char (/ (buffer-size) 2))
	(re-search-forward "^(" nil t)
	(delete-region (point-min) (point)))
      (goto-char (point-max))
      (save-excursion
	(ensime-pprint-event event (current-buffer)))
      (when (and (boundp 'outline-minor-mode)
		 outline-minor-mode)
	(hide-entry))
      (goto-char (point-max)))))

(defun ensime-pprint-event (event buffer)
  "Pretty print EVENT in BUFFER with limited depth and width."
  (let ((print-length 20)
	(print-level 6)
	(pp-escape-newlines t))
    (pp (ensime-copy-event-for-print event) buffer)))

(defun ensime-events-buffer ()
  "Return or create the event log buffer."
  (or (get-buffer ensime-event-buffer-name)
      (let ((buffer (get-buffer-create ensime-event-buffer-name)))
	(with-current-buffer buffer
	  (buffer-disable-undo)
	  (set (make-local-variable 'outline-regexp) "^(")
	  (set (make-local-variable 'comment-start) ";")
	  (set (make-local-variable 'comment-end) "")
	  (when ensime-outline-mode-in-events-buffer
	    (outline-minor-mode)))
	buffer)))

(defun ensime-copy-event-for-print (event)
  "Return a mostly-deep-copy of EVENT, with long strings trimmed. Lists are
copied. Strings are either used unchanged, or relpaced with shortened
copies. All other objects are used unchanged. List must not contain cycles."
  (cond
   ((stringp event)
    (if (> (length event) 500) (concat (substring event 0 500) "...") event))
   ((listp event)
    (mapcar #'ensime-copy-event-for-print event))
   (t event)))


;;; Protocol event handler (the guts)

;;; This is the protocol in all its glory. The input to this function
;;; is a protocol event that either originates within Emacs or arrived
;;; over the network from the ENSIME server.
;;;
;;; Each event is a list beginning with a keyword and followed by
;;; arguments. The keyword identifies the type of event. Events
;;; originating from Emacs have names starting with :emacs- and events
;;; from the ENSIME server don't.

(defvar ensime-event-hooks)

(defun ensime-dispatch-event (event &optional process)
  (let ((ensime-dispatching-connection (or process (ensime-connection))))
    (or (run-hook-with-args-until-success 'ensime-event-hooks event)
	(destructure-case event
                          ((:swank-rpc form continuation)
                           (let ((id (incf (ensime-continuation-counter))))
                             (ensime-send `(:swank-rpc ,form ,id))
                             (push (cons id continuation) (ensime-rex-continuations))
                             ))

                          ((:return value id)
                           (let ((rec (assq id (ensime-rex-continuations))))

                             (cond (rec (setf (ensime-rex-continuations)
                                              (remove rec (ensime-rex-continuations)))
                                        (funcall (cdr rec) value)
                                        (force-mode-line-update t)
                                        (ensime-event-sig :return-value value))
                                   (t
                                    (error "Unexpected reply: %S %S" id value)))))


                          ((:full-typecheck-finished)
                           (when (ensime-awaiting-full-typecheck (ensime-connection))
                             (message "Typecheck finished.")
                             (setf (ensime-awaiting-full-typecheck
                                    (ensime-connection)) nil)
                             (ensime-show-all-errors-and-warnings))
                           (ensime-event-sig :full-typecheck-finished t))

                          ((:compiler-ready)
                           (ensime-handle-compiler-ready)
                           (ensime-event-sig :compiler-ready t))

                          ((:compiler-restarted)
                           ;; Ignore for now
                           )

                          ((:indexer-ready)
                           (ensime-event-sig :indexer-ready t))

                          ((:scala-notes result)
                           (ensime-add-notes 'scala result))

                          ((:java-notes result)
                           (ensime-add-notes 'java result))

                          ((:clear-all-scala-notes)
                           (ensime-clear-notes 'scala))

                          ((:clear-all-java-notes)
                           (ensime-clear-notes 'java))

                          ((:debug-event evt)
                           (ensime-db-handle-event evt)
                           (ensime-event-sig :debug-event evt))

                          ((:channel-send id msg)
                           (ensime-channel-send (or (ensime-find-channel id)
                                                    (error "Invalid channel id: %S %S" id msg))
                                                msg))
                          ((:emacs-channel-send id msg)
                           (ensime-send `(:emacs-channel-send ,id ,msg)))
                          ((:read-from-minibuffer thread tag prompt initial-value)
                           (ensime-read-from-minibuffer-for-swank
                            thread tag prompt initial-value))
                          ((:y-or-n-p thread tag question)
                           (ensime-y-or-n-p thread tag question))
                          ((:emacs-return-string thread tag string)
                           (ensime-send `(:emacs-return-string ,thread ,tag ,string)))
                          ((:new-features features)
                           (setf (ensime-server-features) features))
                          ((:eval-no-wait fun args)
                           (apply (intern fun) args))
                          ((:eval thread tag form-string)
                           (ensime-check-eval-in-emacs-enabled)
                           (ensime-eval-for-lisp thread tag form-string))
                          ((:emacs-return thread tag value)
                           (ensime-send `(:emacs-return ,thread ,tag ,value)))
                          ((:ed what)
                           (ensime-ed what))
                          ((:background-message code detail)
                           (ensime-background-message "%s" detail))
                          ((:reader-error code detail)
                           (ensime-with-popup-buffer
                            ("*Ensime Error*")
                            (princ (format "Invalid protocol message:\n%s\n\n%S"
                                           condition packet))
                            (goto-char (point-min)))
                           (error "Invalid protocol message"))
                          ))))

(defun ensime-send (sexp)
  "Send SEXP directly over the wire on the current connection."
  (ensime-net-send sexp (ensime-connection)))


(defun ensime-handle-compiler-ready ()
  "Do any work that should be done the first time the analyzer becomes
 ready for requests."
  (message "ENSIME ready. %s" (ensime-random-words-of-encouragement))
  (setf (ensime-analyzer-ready (ensime-connection)) t)
  (ensime-sem-high-refresh-all-buffers))

;;; Words of encouragement

(defun ensime-user-first-name ()
  (let ((name (if (string= (user-full-name) "")
		  (user-login-name)
		(user-full-name))))
    (string-match "^[^ ]*" name)
    (capitalize (match-string 0 name))))

(defvar ensime-words-of-encouragement
  `("Let the hacking commence!"
    "Hacks and glory await!"
    "Hack and be merry!"
    "May the source be with you!"
    "Death to null!"
    "Find closure!"
    "May the _ be with you."
    "M-x be_cool"
    "CanBuildFrom[List[Dream], Reality, List[Reality]]"
    ,(format "%s, this could be the start of a beautiful program."
	     (ensime-user-first-name)))
  "Scientifically-proven optimal words of hackerish encouragement.")

(defun ensime-random-words-of-encouragement ()
  "Return a string of hackerish encouragement."
  (eval (nth (random (length ensime-words-of-encouragement))
	     ensime-words-of-encouragement)))


;;; RPC calls and support functions

;;; `ensime-rex' is the RPC primitive which is used to implement both
;;; `ensime-eval' and `ensime-eval-async'. You can use it directly if
;;; you need to, but the others are usually more convenient.

(defmacro* ensime-rex ((&rest saved-vars)
                       sexp
                       &rest continuations)
  "(ensime-rex (VAR ...) SEXP CLAUSES ...)

Remote EXecute SEXP.

VARs are a list of saved variables visible in the other forms.  Each
VAR is either a symbol or a list (VAR INIT-VALUE).

SEXP is evaluated and the princed version is sent to Lisp.

CLAUSES is a list of patterns with same syntax as
`destructure-case'.  The result of the evaluation of SEXP is
dispatched on CLAUSES.  The result is either a sexp of the
form (:ok VALUE) or (:abort REASON).  CLAUSES is executed
asynchronously.

Note: don't use backquote syntax for SEXP, because various Emacs
versions cannot deal with that."
  (let ((result (gensym)))
    `(lexical-let ,(loop for var in saved-vars
                         collect (etypecase var
                                   (symbol (list var var))
                                   (cons var)))
       (ensime-dispatch-event
        (list :swank-rpc ,sexp
              (lambda (,result)
                (destructure-case ,result
                                  ,@continuations)))))))

(put 'ensime-rex 'lisp-indent-function 2)

;;; Synchronous requests are implemented in terms of asynchronous
;;; ones. We make an asynchronous request with a continuation function
;;; that `throw's its result up to a `catch' and then enter a loop of
;;; handling I/O until that happens.

(defvar ensime-stack-eval-tags nil
  "List of stack-tags of continuations waiting on the stack.")

(defun ensime-eval (sexp)
  "Evaluate EXPR on the superior Lisp and return the result."
  (let* ((tag (gensym (format "ensime-result-%d-sym"
                              (1+ (ensime-continuation-counter)))))
         (ensime-stack-eval-tags (cons tag ensime-stack-eval-tags)))
    (apply
     #'funcall
     (catch tag
       (ensime-rex (tag sexp)
           sexp

         ((:ok value)
          (if (not (member tag ensime-stack-eval-tags))
              (message
               "Reply to canceled synchronous eval request tag=%S sexp=%S"
               tag sexp)
            (throw tag (list #'identity value))))

         ((:abort code reason)
          (message
           (format
            "Synchronous RPC Aborted: %s" reason))
          (throw tag (list #'identity nil))))

       (let ((debug-on-quit t)
             (inhibit-quit nil)
             (conn (ensime-connection)))
         (while t
           (unless (eq (process-status conn) 'open)
             (error "Lisp connection closed unexpectedly"))
           (accept-process-output nil 1 0)))))))


(defun ensime-eval-async (sexp &optional cont)
  "Evaluate EXPR on the superior Lisp and call CONT with the result."
  (ensime-rex (cont (buffer (current-buffer)))
      sexp
    ((:ok result)
     (when cont
       (if (buffer-live-p buffer)
           (progn
             (set-buffer buffer)
             (funcall cont result))
         (message
          "ENSIME: Asynchronous return could not find originating buffer.")
         )))
    ((:abort code reason)
     (message "Asynchronous RPC Aborted: %s" reason)))
  ;; Guard against arbitrary return values which once upon a time
  ;; showed up in the minibuffer spuriously (due to a bug in
  ;; ensime-autodoc.)  If this ever happens again, returning the
  ;; following will make debugging much easier:
  :ensime-eval-async)


;;; RPC functions

(defun ensime-rpc-doc-uri-at-point (file point)
  (ensime-eval
   `(swank:doc-uri-at-point ,file ,point)))

(defun ensime-rpc-doc-uri-for-symbol (fqn &optional member-name member-signature)
  (ensime-eval
   `(swank:doc-uri-for-symbol ,fqn ,member-name ,member-signature)))

(defun ensime-rpc-symbol-by-name (fqn &optional member-name member-signature)
  (ensime-eval
   `(swank:symbol-by-name ,fqn ,member-name ,member-signature)))

(defun ensime-rpc-method-bytecode (file line)
  (ensime-eval
   `(swank:method-bytecode ,file ,line)))

(defun ensime-rpc-debug-active-vm ()
  (ensime-eval
   `(swank:debug-active-vm)))

(defun ensime-rpc-debug-backtrace (thread-id index count)
  (ensime-eval
   `(swank:debug-backtrace ,thread-id ,index ,count)))

(defun ensime-rpc-async-debug-backtrace (thread-id index count continue)
  (ensime-eval-async
   `(swank:debug-backtrace ,thread-id ,index ,count) continue))

(defun ensime-rpc-debug-locate-name (thread-id name)
  (ensime-eval
   `(swank:debug-locate-name ,thread-id ,name)))

(defun ensime-rpc-debug-value (location)
  (ensime-eval
   `(swank:debug-value ,location)))

(defun ensime-rpc-debug-to-string (thread-id location)
  (ensime-eval
   `(swank:debug-to-string ,thread-id ,location)))

(defun ensime-rpc-debug-set-value (location new-val)
  (ensime-eval
   `(swank:debug-set-value ,location ,new-val)))

(defun ensime-rpc-debug-start (command-line)
  (ensime-eval
   `(swank:debug-start ,command-line)))

(defun ensime-rpc-debug-attach (hostname port)
  (ensime-eval
   `(swank:debug-attach ,hostname ,port)))

(defun ensime-rpc-debug-stop ()
  (ensime-eval
   `(swank:debug-stop)))

(defun ensime-rpc-debug-next (thread-id)
  (ensime-eval
   `(swank:debug-next ,thread-id)))

(defun ensime-rpc-debug-continue (thread-id)
  (ensime-eval
   `(swank:debug-continue ,thread-id)))

(defun ensime-rpc-debug-run ()
  (ensime-eval
   `(swank:debug-run)))

(defun ensime-rpc-debug-step (thread-id)
  (ensime-eval
   `(swank:debug-step ,thread-id)))

(defun ensime-rpc-debug-step-out (thread-id)
  (ensime-eval
   `(swank:debug-step-out ,thread-id)))

(defun ensime-rpc-debug-list-breakpoints ()
  (ensime-eval
   `(swank:debug-list-breakpoints)))

(defun ensime-rpc-debug-set-break (file line)
  (ensime-eval
   `(swank:debug-set-break ,file ,line)))

(defun ensime-rpc-debug-clear-break (file line)
  (ensime-eval
   `(swank:debug-clear-break ,file ,line)))

(defun ensime-rpc-debug-clear-all-breaks ()
  (ensime-eval
   `(swank:debug-clear-all-breaks)))

(defun ensime-rpc-symbol-at-point ()
  (ensime-eval
   `(swank:symbol-at-point ,buffer-file-name ,(ensime-computed-point))))

(defun ensime-rpc-repl-config ()
  "Get the configuration information needed to launch the scala interpreter
with the current project's dependencies loaded. Returns a property list."
  (ensime-eval
   `(swank:repl-config)))

(defun ensime-rpc-remove-file (file-name)
  (ensime-eval `(swank:remove-file ,file-name)))

(defun ensime-rpc-unload-all ()
  (ensime-eval `(swank:unload-all)))

(defun ensime-rpc-async-typecheck-file (file-name continue)
  (if (version< (ensime-protocol-version) "0.8.11")
      (ensime-eval-async `(swank:typecheck-file ,file-name) continue)
    (ensime-eval-async `(swank:typecheck-file (:file ,file-name)) continue)))

(defun ensime-rpc-async-typecheck-files (file-names continue)
  (ensime-eval-async `(swank:typecheck-files ,file-names) continue))

(defun ensime-rpc-async-typecheck-file-with-contents (file-name contents continue)
  (if (version< (ensime-protocol-version) "0.8.11")
      (ensime-eval-async `(swank:typecheck-file ,file-name ,contents) continue)
    (ensime-eval-async `(swank:typecheck-file (:file ,file-name :contents ,contents)) continue)))

(defun ensime-rpc-async-typecheck-all (continue)
  (ensime-eval-async `(swank:typecheck-all) continue))

(defun ensime-rpc-async-format-files (file-names continue)
  (ensime-eval-async `(swank:format-source ,file-names) continue))

(defun ensime-rpc-format-buffer ()
  (assert (version<= "0.8.11" (ensime-protocol-version)))
  (ensime-eval `(swank:format-one-source (:file ,buffer-file-name
                                          :contents ,(ensime-get-buffer-as-string)))))

(defun ensime-rpc-expand-selection (file-name start end)
  (ensime-internalize-offset-fields
   (ensime-eval `(swank:expand-selection
		  ,file-name
		  ,(ensime-externalize-offset start)
		  ,(ensime-externalize-offset end)))
   :start
   :end
   ))


(defun ensime-rpc-import-suggestions-at-point (names max-results)
  (ensime-eval
   `(swank:import-suggestions
     ,buffer-file-name
     ,(ensime-computed-point)
     ,names
     ,max-results
     )))

(defun ensime-rpc-async-public-symbol-search
  (names max-results continue)
  (ensime-eval-async
   `(swank:public-symbol-search
     ,names
     ,max-results
     ) continue))

(defun ensime-rpc-uses-of-symbol-at-point ()
  (ensime-eval
   `(swank:uses-of-symbol-at-point
     ,buffer-file-name
     ,(ensime-computed-point)
     )))

(defun ensime-rpc-package-member-completions (path &optional prefix)
  (ensime-eval
   `(swank:package-member-completion ,path ,(or prefix ""))))

(defun ensime-rpc-get-type-by-id (id)
  (if (and (integerp id) (> id -1))
      (ensime-eval
       `(swank:type-by-id ,id))))

(defun ensime-rpc-get-type-by-name (name)
  (ensime-eval
   `(swank:type-by-name ,name)))

(defun ensime-rpc-get-type-by-name-at-point (name)
  (ensime-eval
   `(swank:type-by-name-at-point
     ,name ,buffer-file-name ,(ensime-computed-point))))

(defun ensime-rpc-get-type-at-point ()
  (ensime-eval
   `(swank:type-at-point ,buffer-file-name ,(ensime-computed-point))))

(defun ensime-rpc-inspect-type-at-point ()
  (ensime-eval
   `(swank:inspect-type-at-point ,buffer-file-name ,(ensime-computed-point))))

(defun ensime-rpc-inspect-type-at-range (&optional range)
  (ensime-eval
   `(swank:inspect-type-at-point ,buffer-file-name
                                 ,(or range (ensime-computed-range)))))

(defun ensime-rpc-inspect-type-by-id (id)
  (if (and (integerp id) (> id -1))
      (ensime-eval
       `(swank:inspect-type-by-id ,id))))

(defun ensime-rpc-inspect-type-by-name (name)
  (ensime-eval
   `(swank:inspect-type-by-name ,name)))

(defun ensime-rpc-inspect-package-by-path (path)
  (ensime-eval
   `(swank:inspect-package-by-path ,path)))

(defun ensime-rpc-peek-undo ()
  (ensime-eval
   `(swank:peek-undo)))

(defun ensime-rpc-exec-undo (id)
  (ensime-eval
   `(swank:exec-undo ,id)))

(defun ensime-rpc-refactor-prepare
  (proc-id refactor-type params non-interactive continue blocking)
  (if blocking
      (ensime-eval
       `(swank:prepare-refactor
	 ,proc-id ,refactor-type ,params ,(not non-interactive)))
    (ensime-eval-async
     `(swank:prepare-refactor
       ,proc-id ,refactor-type ,params ,(not non-interactive)) continue)))

(defun ensime-rpc-refactor-exec (proc-id refactor-type continue)
  (ensime-eval-async `(swank:exec-refactor ,proc-id , refactor-type) continue))

(defun ensime-rpc-refactor-cancel (proc-id)
  ;(ensime-eval-async `(swank:cancel-refactor ,proc-id) #'identity))
  (ensime-eval-async
   `(swank:cancel-refactor ,proc-id)
   (lambda (result)
     (kill-buffer ensime-refactor-info-buffer-name)
     result)))


(defun ensime-rpc-shutdown-server ()
  (ensime-eval `(swank:shutdown-server)))

(defun ensime-rpc-symbol-designations (file start end requested-types continue)
  (ensime-eval-async `(swank:symbol-designations ,file ,start ,end ,requested-types)
		     continue))

(defun ensime-rpc-get-call-completion (id)
  (if (and (integerp id) (> id -1))
      (ensime-eval
       `(swank:call-completion ,id))))

(defun ensime-rpc-completions-at-point (&optional max-results case-sens)
  (let* ((should-write-buffer (version< (ensime-protocol-version) "0.8.11"))
         (file-info
          (if should-write-buffer
              buffer-file-name
            `(:file ,buffer-file-name :contents ,(ensime-get-buffer-as-string)))))
    (when should-write-buffer (ensime-write-buffer nil t))
    (ensime-eval
     `(swank:completions
       ,file-info
       ,(ensime-computed-point)
       ,(or max-results 0)
       ,case-sens
       t ;; reload
       ))))

(defun ensime-rpc-async-completions-at-point (max-results case-sens continue)
  (let* ((should-write-buffer (version< (ensime-protocol-version) "0.8.11"))
         (file-info
          (if should-write-buffer
              buffer-file-name
            `(:file ,buffer-file-name :contents ,(ensime-get-buffer-as-string)))))
    (when should-write-buffer (ensime-write-buffer nil t))
  (ensime-eval-async
   `(swank:completions
     ,file-info
     ,(ensime-computed-point)
     ,(or max-results 0)
     ,case-sens
     t ;; reload
     ) continue)))


(provide 'ensime-client)

;; Local Variables:
;; no-byte-compile: t
;; End:

