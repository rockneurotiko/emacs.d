;;; javarun.el --- Minor mode for quick development of Java programs

;; Copyright (C) 2010, 2013 Daniel H. Leidisch

;; Author: Daniel H. Leidisch <public@leidisch.net>
;; Keywords: languages
;; URL: https://github.com/danlei/javarun
;; Version: 0.1.1

;; This file is NOT part of GNU Emacs.

;; This is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; See <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This minor mode allows for quick compilation and running of Java
;; programs, making the edit-compile-run cycle a little less annoying.
;; On success, the output of the program is shown in a popup buffer.
;; Compilation errors otherwise.

;;; Code:


(defgroup javarun '()
  "Java compilation convenience for small command-line programs."
  :group 'languages
  :prefix "javarun")

(defcustom javarun-java-path ""
  "The path where java and javac can be found.

This variable only needs to be set, if the java and javac
programs are not on the system path."
  :type 'directory)

(defcustom javarun-javac-program "javac"
  "The program used to compile the Java program."
  :type 'file)

(defcustom javarun-java-program "java"
  "The program used to run the compiled Java program."
  :type 'file)

(defcustom javarun-cygdir "C:/cygwin/"
  "The Cygwin root directory path.

This variable is meant be used with Cygwin Emacs in combination
with non-Cygwin Java. It is only relevant, if `system-type' is
set to cygwin."
  :type 'directory)

(defcustom javarun-clear-java-output t
  "If t, clear the java output buffer before each run."
  :type 'boolean
  :safe 'booleanp)

(defcustom javarun-clear-javac-output t
  "If t, clear the javac output buffer before each run."
  :type 'boolean
  :safe 'booleanp)

(defcustom javarun-switch-to-popup-buffer t
  "If t, switch to popup buffers after popping up."
  :type 'boolean
  :safe 'booleanp)

(defcustom javarun-popup-scroll-to-bottom nil
  "If t, scroll to the bottom of popup buffers after popping up."
  :type 'boolean
  :safe 'booleanp)

(defcustom javarun-single-file-lazy-compile nil
  "If t, only invoke the compiler if the source actually changed.

If this option is set, a little time can be saved when repeatedly
invoking a single file program without changes. The compiler will
only be invoked, if the source file is younger than its
respective class file. However, when working with multiple
changing files, this option should be disabled, since only the
file of the current buffer will be checked for changes."
  :type 'boolean
  :safe 'booleanp)


(defvar javarun-old-window-configuration nil
  "The window configuration as it was before a javarun popup.")

(define-derived-mode javarun-popup-mode special-mode "Javarun Popup")

(define-key javarun-popup-mode-map (kbd "q") 'javarun-bury-popup-buffer)
(define-key javarun-popup-mode-map (kbd "c") 'javarun-clear-popup-buffer)
(define-key javarun-popup-mode-map (kbd "s") 'javarun-save-popup-buffer)

;;;###autoload
(define-minor-mode javarun-mode
  "Toggle Javarun mode.

With no argument, this command toggles the mode. A non-null
prefix argument turns on the mode; a null prefix argument turns
off the mode.

Javarun is intended to be a useful shortcut when developing small
command-line Java programs. This minor mode provides the command
`javarun', which will compile and run a Java file and show its
results in a popup buffer.

For further options, see the customize group `javarun'.

javarun.el is located at URL `http://github.com/danlei/javarun'.

Keybindings:
\\{javarun-mode}"
  :init-value nil
  :lighter " JRun"
  :keymap '(("\C-c\C-c" . javarun)))

(defun javarun-bury-popup-buffer (&optional buffer)
  "Bury buffer and restore old window configuration.

If no BUFFER is given, it defaults to the `current-buffer'."
  (interactive)
  (bury-buffer (or buffer (current-buffer)))
  (set-window-configuration javarun-old-window-configuration))

(defun javarun-clear-popup-buffer (&optional buffer)
  "Clear the current buffer or BUFFER, if given."
  (interactive)
  (let ((inhibit-read-only t))
    (with-current-buffer (or buffer (current-buffer))
      (erase-buffer))))

(defun javarun-save-popup-buffer (&optional buffer)
  "Copy contents of the current buffer or BUFFER, if given."
  (interactive)
  (with-current-buffer (or buffer (current-buffer))
    (save-excursion
      (kill-ring-save (point-min) (point-max)))))

(defun javarun-visible-buffers ()
  "Return the list of visible buffers."
  (let ((visible-buffers '()))
    (walk-windows (lambda (window)
                    (push (window-buffer window) visible-buffers)))
    visible-buffers))

(defun javarun-buffer-visible-p (buffer)
  "Return t if BUFFER is visible."
  (consp (memq buffer (javarun-visible-buffers))))

(defun javarun-popup-buffer (&optional buffer)
  "Popup the current buffer or BUFFER, if given.

Save the old window configuration in the variable
`javarun-old-window-configuration'. The function
`javarun-bury-popup-buffer' buries the popup buffer, and restores
the old window configuration. If the variable
`javarun-switch-to-popup-buffer' is t, switch to the popup buffer
after popping up. If the variable
`javarun-popup-scroll-to-bottom' is t, scroll to bottom after
popping up."
  (let ((buffer (or buffer (current-buffer))))
    (unless (javarun-buffer-visible-p buffer)
      (setq javarun-old-window-configuration (current-window-configuration)))
    (with-current-buffer buffer
      (javarun-popup-mode))
    (let ((window (display-buffer buffer)))
      (if javarun-switch-to-popup-buffer
          (progn (select-window window t)
                 (when javarun-popup-scroll-to-bottom
                   (goto-char (point-max))))
        (with-selected-window window
          (when javarun-popup-scroll-to-bottom
            (goto-char (point-max))))))))

(defun javarun-read-args ()
  "Read whitespace-separated command line arguments interactively.

All arguments are evaluated as Emacs Lisp forms."
  (mapcar (lambda (x)
            (if (stringp x)
                x
                (prin1-to-string (eval x))))
          (car (read-from-string
                (concat "(" (read-string "Command line arguments: ") ")")))))

(defun javarun-maybe-clear-buffers ()
  "Clear output buffers if configured to do so.

Clear output buffers if they exist and their respective option,
i.e. the variable `javarun-clear-java-output' or the variable
`javarun-clear-javac-output' is set to t."
  (let ((java-buffer (get-buffer "*java-output*"))
        (javac-buffer (get-buffer "*javac-output*")))
    (and java-buffer
         javarun-clear-java-output
         (javarun-clear-popup-buffer java-buffer))
    (and javac-buffer
         javarun-clear-javac-output
         (javarun-clear-popup-buffer javac-buffer))))

(defun javarun-offer-save (&optional buffer)
  "Offer to save the current buffer if needed, or BUFFER, if given."
  (let ((buffer (or buffer (current-buffer))))
    (and (buffer-modified-p buffer)
         (y-or-n-p "Buffer modified; save? ") ;
         (with-current-buffer buffer
           (save-buffer)))))

;;;###autoload
(defun javarun (argsp)
  "Compile, and (if successful) run a Java program.

The output of the program (or the compiler error messages, if
the compilation failed) are shown in a popup window by
`javarun-popup-buffer'.

If a positive prefix argument ARGSP is given, read command line
arguments interactively using the function `javarun-read-args'.
The arguments are evaluated expressions, so strings have to be
quoted. For example:

  \"foo bar\" (+ 1 2) \"baz\"

will pass the arguments \"foo bar\", 3, and \"bar\"."
  (interactive "p")
  (javarun-maybe-clear-buffers)
  (javarun-offer-save)
  (if (not (javarun-compile (javarun-generate-buffer-file-name)))
      (javarun-popup-buffer (get-buffer "*javac-output*"))
    (apply 'call-process
           (concat (file-name-as-directory javarun-java-path)
                   javarun-java-program)
           nil "*java-output*" t
           (file-name-nondirectory
            (file-name-sans-extension (buffer-file-name)))
           (when (/= argsp 1) (javarun-read-args)))
    (javarun-popup-buffer (get-buffer "*java-output*"))))

(defun javarun-generate-buffer-file-name (&optional buffer)
  "Return buffer file name of current buffer or BUFFER.

Mangle the path for use under Cygwin. Throw an error, if BUFFER
has no associated file."
  (let* ((buffer-file (or (buffer-file-name (or buffer (current-buffer)))
                          (error "Buffer has no associated file"))))
    (if (eq system-type 'cygwin)
        (concat (file-name-as-directory javarun-cygdir)
                (substring buffer-file 1))
      buffer-file)))

(defun javarun-compile (java-file)
  "Compile JAVA-FILE.

Compile JAVA-FILE using `javarun-javac-program'. If
`javarun-single-file-lazy-compile' is t, only invoke the compiler
if the file of the current buffer has been modified since the
last compilation. Return t on success."
  (unless (file-exists-p java-file)
    (error "Java file not found"))
  (let ((class-file (concat (file-name-sans-extension java-file) ".class")))
    (if (and javarun-single-file-lazy-compile
             (file-exists-p class-file)
             (time-less-p (nth 5 (file-attributes java-file))
                          (nth 5 (file-attributes class-file))))
        t
      (zerop (call-process (concat (file-name-as-directory javarun-java-path)
                                   javarun-javac-program)
                           nil "*javac-output*" t java-file)))))

(provide 'javarun)

;;; javarun.el ends here
