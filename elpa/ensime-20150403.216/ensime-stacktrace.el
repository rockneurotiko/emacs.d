;;; ensime-stacktrace.el - Paste buffer for stack traces

(defconst ensime-stacktrace-buffer-name-base "*ensime-stacktrace*")

(defvar ensime-stacktrace-buffer-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") 'ensime-stacktrace-highlight)
    (define-key map (kbd "C-c C-q") 'quit-window)
    map)
  "Keymap for `ensime-stacktrace-buffer-mode'.")

(define-minor-mode ensime-stacktrace-buffer-mode
  "Mode for highlighting stack traces"
  nil
  nil
  ensime-stacktrace-buffer-map)

(defun ensime-stacktrace-build-buffer-name ()
  "Return the name of the project-specific stacktrace buffer."
  (format "%s<%s>"
          ensime-stacktrace-buffer-name-base
          (plist-get (ensime-config) :project-name)))

(defun ensime-stacktrace-switch ()
  "Switch to buffer containing the stack trace parser"
  (interactive)
  (let ((stacktrace-buf-name (ensime-stacktrace-build-buffer-name)))
    (unless (equal stacktrace-buf-name (buffer-name))
      (ensime-with-conn-interactive
       conn
       (let ((buf (get-buffer-create stacktrace-buf-name)))
         (switch-to-buffer-other-window buf)
         (setq ensime-buffer-connection conn)
         (ensime-stacktrace-buffer-mode 1)
         (font-lock-mode 1)
         (when (= (buffer-size buf) 0)
           (insert ";; Stack trace buffer\n")
           (insert ";; Paste a stack trace below and press `C-c C-c' to create links to source code.\n")
           (insert ";; Press `C-c C-q' to leave this buffer\n")
           (insert "\n"))
        (local-set-key (kbd "C-c C-c") 'ensime-stacktrace-highlight)
        (local-set-key (kbd "C-c C-q") 'quit-window)
        (current-buffer))))))

(defun ensime-stacktrace-highlight ()
  (interactive)
  "Parse the current buffer and look for lines that looks for a stack trace.
Create links to the source code."
  (set-text-properties (point-min) (point-max) nil)
  (ensime-inf-highlight-stack-traces (point-min) (point-max)))

(provide 'ensime-stacktrace)

;; Local Variables:
;; no-byte-compile: t
;; End:

