;;; javarun-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "javarun" "javarun.el" (21734 10160 958366
;;;;;;  382000))
;;; Generated autoloads from javarun.el

(autoload 'javarun-mode "javarun" "\
Toggle Javarun mode.

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
\\{javarun-mode}

\(fn &optional ARG)" t nil)

(autoload 'javarun "javarun" "\
Compile, and (if successful) run a Java program.

The output of the program (or the compiler error messages, if
the compilation failed) are shown in a popup window by
`javarun-popup-buffer'.

If a positive prefix argument ARGSP is given, read command line
arguments interactively using the function `javarun-read-args'.
The arguments are evaluated expressions, so strings have to be
quoted. For example:

  \"foo bar\" (+ 1 2) \"baz\"

will pass the arguments \"foo bar\", 3, and \"bar\".

\(fn ARGSP)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; javarun-autoloads.el ends here
