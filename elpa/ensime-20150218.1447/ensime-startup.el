;;; ensime-startup.el --- download and launch ENSIME server

(defun ensime--get-cache-dir (config)
  (let ((cache-dir (plist-get config :cache-dir)))
    (unless cache-dir
      (error "Cache dir in ensime configuration file appears to be unset"))
    cache-dir))

(defun ensime--get-root-dir (config)
  (let ((root-dir (plist-get config :root-dir)))
    (unless root-dir
      (error "Root dir in ensime configuration file appears to be unset"))
    root-dir))

(defun ensime--get-name (config)
  (let ((name (plist-get config :name)))
    (unless name
      (error "Name in ensime configuration file appears to be unset"))
    name))

(defun ensime-update ()
  "Install the most recent version of ENSIME server."
  (interactive)
    (let* ((config-file (ensime-config-find))
           (config (ensime-config-load config-file))
           (scala-version (plist-get config :scala-version)))
      (ensime--update-server scala-version `(lambda () (message "ENSIME server updated.")))))

(defun ensime--maybe-update-and-start (&optional host port)
  (if (and host port)
      ;; When both host and port are provided, we assume we're connecting to
      ;; an existing, listening server.
      (ensime--retry-connect nil host (lambda () port) config cache-dir)
    (let* ((config-file (ensime-config-find))
           (config (ensime-config-load config-file))
           (scala-version (plist-get config :scala-version)))
      (if (ensime--classfile-needs-refresh-p (ensime--classpath-file scala-version))
          (ensime--update-server scala-version `(lambda () (ensime--1 ,config-file)))
        (ensime--1 config-file)))))

(defun* ensime--1 (config-file)
  (when (and (ensime-source-file-p) (not ensime-mode))
    (ensime-mode 1))
  (let* ((config (ensime-config-load config-file))
         (root-dir (ensime--get-root-dir config) )
         (cache-dir (file-name-as-directory (ensime--get-cache-dir config)))
         (name (ensime--get-name config))
         (scala-version (plist-get config :scala-version))
         (server-env (or (plist-get config :server-env) ensime-default-server-env))
         (buffer (or (plist-get config :buffer) (concat ensime-default-buffer-prefix name)))
         (server-java (file-name-as-directory (plist-get config :java-home)))
         (server-flags (or (plist-get config :java-flags) ensime-default-java-flags)))
    (make-directory cache-dir 't)

    (let* ((server-proc
            (ensime--maybe-start-server
             (generate-new-buffer-name (concat "*" buffer "*"))
             server-java scala-version server-flags
             (list* (concat "JDK_HOME=" server-java)
                    (concat "JAVA_HOME=" server-java)
                    server-env)
             config-file
             cache-dir))
           (host "127.0.0.1")
           (port (lambda () (ensime-read-swank-port
                             (concat cache-dir "/port")))))

      ;; Surface the server buffer so user can observe the startup progress.
      (display-buffer-at-bottom (process-buffer server-proc) nil)

      ;; Store the config on the server process so we can identify it later.
      (process-put server-proc :ensime-config config)
      (push server-proc ensime-server-processes)
      (ensime--retry-connect server-proc host port config cache-dir))))


;; typecheck continually when idle

(defvar ensime-idle-typecheck-timer nil
  "Timer called when emacs is idle")

(defvar ensime-last-change-time 0
  "Time of last buffer change")

(defun ensime-idle-typecheck-set-timer ()
  (when (timerp ensime-idle-typecheck-timer)
    (cancel-timer ensime-idle-typecheck-timer))
  (setq ensime-idle-typecheck-timer
        (run-with-timer nil
                        ensime-typecheck-idle-interval
                        'ensime-idle-typecheck-function)))

(defun ensime-after-change-function (start stop len)
  (set (make-local-variable 'ensime-last-change-time) (float-time)))

(defun ensime-idle-typecheck-function ()
  (when (and ensime-typecheck-when-idle
             (ensime-connected-p)
             (ensime-analyzer-ready))
    (let* ((now (float-time))
           (last-typecheck (ensime-last-typecheck-run-time (ensime-connection)))
           (earliest-allowed-typecheck (+ last-typecheck ensime-typecheck-interval)))
      (when (and (>= now (+ ensime-last-change-time ensime-typecheck-idle-interval))
                 (>= now earliest-allowed-typecheck)
                 (< last-typecheck ensime-last-change-time))
        (ensime-typecheck-current-file t)
        (ensime-sem-high-refresh-hook)))))

(defun ensime-reload ()
  "Re-initialize the project with the current state of the config file.
Analyzer will be restarted. All source will be recompiled."
  (interactive)
  (let* ((conn (ensime-connection))
	 (current-conf (ensime-config conn))
	 (force-dir (plist-get current-conf :root-dir))
	 (config (ensime-config-load (ensime-config-find force-dir) force-dir)))
    (when (not (null config))
      (ensime-set-config conn config)
      (ensime-init-project conn))))

(defun ensime--maybe-start-server (buffer java-home scala-version flags env config-file cache-dir)
  "Return a new or existing server process."
  (let ((existing (comint-check-proc buffer)))
    (if existing existing
      (ensime--start-server buffer java-home scala-version flags env config-file cache-dir))))

(defun ensime--user-directory ()
  (file-name-as-directory
   (expand-file-name "ensime" user-emacs-directory)))

(defun ensime--classpath-file (scala-version)
  (expand-file-name
   (format "classpath_%s_%s"
           scala-version
           (ensime--select-server-version scala-version))
   (ensime--user-directory)))

(defun ensime--classfile-needs-refresh-p (classfile)
  (if (file-exists-p classfile)
      (let ((ensime-el (locate-file "ensime" load-path '(".el" ".elc"))))
        (if ensime-el
            (let ((classfile-mtime (nth 5 (file-attributes classfile)))
                  (ensime-files (directory-files-and-attributes (file-name-directory ensime-el)
                                                                nil
                                                                "^ensime.*\\.elc?$")))
              (some (lambda (a) (time-less-p classfile-mtime (nth 6 a))) ensime-files))
          nil))
    t))

(defun ensime--update-sentinel (process event scala-version on-success-fn)
  (cond
   ((equal event "finished\n")
    (let ((classpath-file (ensime--classpath-file scala-version)))
      (if (file-exists-p classpath-file)
          (progn
            (when-let
             (win (get-buffer-window (process-buffer process)))
             (delete-window win))
            (kill-buffer (process-buffer process))
            (funcall on-success-fn))
        (message "Could not create classpath file %s" classpath-file))))
   (t
    (message "Process %s exited: %s" process event))))

(defun ensime--update-server (scala-version on-success-fn)
  (with-current-buffer (get-buffer-create (generate-new-buffer-name "*ensime-update*"))
    (let* ((default-directory (file-name-as-directory
                               (make-temp-file "ensime_update_" t)))
           (classpath-file (ensime--classpath-file scala-version))
           (buildfile (concat default-directory "build.sbt"))
           (buildcontents (ensime--create-sbt-start-script scala-version))
           (buildpropsfile (concat default-directory "project/build.properties")))

      (when (file-exists-p classpath-file) (delete-file classpath-file))
      (make-directory (file-name-directory classpath-file) t)
      (ensime-write-to-file buildfile buildcontents)
      (ensime-write-to-file buildpropsfile "sbt.version=0.13.7\n")

      (if (executable-find ensime-sbt-command)
          (let ((process (start-process "*ensime-update*" (current-buffer)
                                        ensime-sbt-command "saveClasspath" "clean")))
            (display-buffer-at-bottom (current-buffer) nil)
            (set-process-filter process
				;; Log output on CI testing runs.
				`(lambda (process text)
				   (when (not (null window-system))
				     (princ text 'external-debugging-output))))
            (set-process-sentinel process
                                  `(lambda (process event)
                                     (ensime--update-sentinel process
                                                              event
                                                              ,scala-version
                                                              ',on-success-fn)))
            (message "Updating ENSIME server..."))
        (error "sbt command not found")))))

(defvar ensime-server-process-start-hook nil
  "Hook called whenever a new process gets started.")

(defvar ensime--classpath-separator
  (if (find system-type '(cygwin windows-nt)) ";" ":")
  "Separator used in Java classpaths")

(defun ensime--start-server (buffer java-home scala-version flags user-env config-file cache-dir)
  "Start an ensime server in the given buffer and return the created process.
BUFFER is the buffer to receive the server output.
FLAGS is a list of JVM flags.
USER-ENV is a list of environment variables.
CACHE-DIR is the server's persistent output directory."
  (message "ENSIME server starting...")
  (with-current-buffer (get-buffer-create buffer)
    (comint-mode)
    (let* ((default-directory cache-dir)
           (tools-jar (concat java-home "lib/tools.jar"))
           (classpath-file (ensime--classpath-file scala-version))
           (classpath (concat tools-jar
                              ensime--classpath-separator
                              (ensime-read-from-file classpath-file)))
           (process-environment (append user-env process-environment))
           (java-command (concat java-home "bin/java"))
           (args (-flatten (list
                            "-classpath" classpath
                            "-Dscala.usejavacp=true"
                            flags
                            (concat "-Densime.config=" (expand-file-name config-file))
                            "org.ensime.server.Server"))))

      (set (make-local-variable 'comint-process-echoes) nil)
      (set (make-local-variable 'comint-use-prompt-regexp) nil)

      (insert (format "Starting ENSIME server: %s %s\n"
                      java-command
                      (mapconcat 'identity args " ")))
      (if (executable-find java-command)
          (comint-exec (current-buffer) buffer java-command nil args)
        (error "java command %s not found" java-command))
      ;; Make sure we clean up nicely (required on Windows, or port files won't
      ;; be removed).
      (add-hook 'kill-emacs-hook 'ensime-interrupt-all-servers)
      (add-hook 'kill-buffer-hook 'ensime-interrupt-buffer-process nil t)
      (let ((proc (get-buffer-process (current-buffer))))
        (ensime-set-query-on-exit-flag proc)
        (run-hooks 'ensime-server-process-start-hook)
        proc))))

(defun ensime--select-server-version(scala-version) "0.9.10-SNAPSHOT")

(defun ensime--create-sbt-start-script (scala-version)
  ;; emacs has some weird case-preservation rules in regexp replace
  ;; see http://github.com/magnars/s.el/issues/62
  (s-replace-all (list (cons "_scala_version_" scala-version)
                       (cons "_server_version_" (ensime--select-server-version
                                                 scala-version))
                       (cons "_classpath_file_" (ensime--classpath-file scala-version)))
                 ensime--sbt-start-template))


(defconst ensime--sbt-start-template
"
import sbt._
import IO._
import java.io._

scalaVersion := \"_scala_version_\"

resolvers += Resolver.sonatypeRepo(\"snapshots\")

resolvers += \"Typesafe repository\" at \"http://repo.typesafe.com/typesafe/releases/\"

resolvers += \"Akka Repo\" at \"http://repo.akka.io/repository\"

libraryDependencies += \"org.ensime\" %% \"ensime\" % \"_server_version_\"

val saveClasspathTask = TaskKey[Unit](\"saveClasspath\", \"Save the classpath to a file\")

saveClasspathTask := {
  val managed = (managedClasspath in Runtime).value.map(_.data.getAbsolutePath)
  val unmanaged = (unmanagedClasspath in Runtime).value.map(_.data.getAbsolutePath)
  val out = file(\"_classpath_file_\")
  write(out, (unmanaged ++ managed).mkString(File.pathSeparator))
}
")

(defun ensime-shutdown()
  "Request that the current ENSIME server kill itself."
  (interactive)
  (when (ensime-connected-p)
    (ensime-quit-connection (ensime-connection))))

(defun ensime-configured-project-root ()
  "Return root path of the current project as defined in the
config file and stored in the current connection. Nil is returned
if there is no active connection, or if the project root was not
defined."
  (when (ensime-connected-p)
    (let ((config (ensime-config (ensime-connection))))
      (plist-get config :root-dir))))

(defun ensime-read-swank-port (portfile)
  "Read the Swank server port number from the `cache-dir',
   or nil if none was found."
  (when (file-exists-p portfile)
    (save-excursion
      (with-temp-buffer
	(insert-file-contents portfile)
	(goto-char (point-min))
	(let ((port (read (current-buffer))))
	  (assert (integerp port))
	  port)))))

(defun ensime--retry-connect (server-proc host port-fn config cache-dir)
  "When application of port-fn yields a valid port, connect to the port at the
 given host. Otherwise, schedule ensime--retry-connect for re-execution after 6
 seconds."
  (cond (ensime--abort-connection
	 (setq ensime--abort-connection nil)
	 (message "Aborted"))
	((and server-proc (eq (process-status server-proc) 'exit))
	 (message "Failed to connect: server process exited."))
	(t
	 (let ((port (funcall port-fn)))
	   (if port
	       (progn
		 (ensime--connect host port config)
		 ;; Kill the window displaying the server buffer if it's still
		 ;; visible.
		 (when-let
		  (win (get-buffer-window (process-buffer server-proc)))
		  (delete-window win)))
	     (run-at-time
	      "6 sec" nil 'ensime-timer-call 'ensime--retry-connect
	      server-proc host port-fn config cache-dir))))))

(defun ensime--connect (host port config)
  (let ((c (ensime-connect host port)))
    (ensime-set-config c config)
    (let ((ensime-dispatching-connection c))
      (ensime-eval-async
       '(swank:connection-info)
       (ensime-curry #'ensime-handle-connection-info c)))))

(defun ensime-timer-call (fun &rest args)
  "Call function FUN with ARGS, reporting all errors.
   The default condition handler for timer functions (see
   `timer-event-handler') ignores errors."
  (condition-case data
      (apply fun args)
    (error (debug nil (list "Error in timer" fun args data)))))

(defvar ensime--abort-connection nil)

(defun ensime--abort-connection ()
  "Abort connection the current connection attempt."
  (interactive)
  (setq ensime-abort-connection 't))

(defun ensime-init-project (conn)
  "Notify the server that we are ready for project events."
  (cond
   ;; TODO(back_compat)
   ((version<= (ensime-protocol-version conn) "0.8.9")
    (ensime-eval-async `(swank:init-project (:name "NA")) 'identity))

   (t (ensime-eval-async `(swank:init-project) 'identity))))


(provide 'ensime-startup)

;; Local Variables:
;; no-byte-compile: t
;; End:
