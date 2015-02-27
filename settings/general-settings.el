;--------------------------------;
;;; General or Global Settings ;;;
;--------------------------------;

;; ; set PATH, because we don't load .bashrc
;; ; function from https://gist.github.com/jakemcc/3887459
;; (defun set-exec-path-from-shell-PATH ()
;;   (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
;;   (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo -n $PATH'")))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (if window-system (set-exec-path-from-shell-PATH))

;; ; language
;; (setq current-language-environment "English")

;; ; don't show the startup screen
;; (setq inhibit-startup-screen 1)
;; ; don't show the menu bar
;; (menu-bar-mode 0)
;; ; don't show the tool bar
;; (require 'tool-bar)
;; (tool-bar-mode 0)
;; ; don't show the scroll bar
;; (if window-system (scroll-bar-mode 0))

;; ; turn on mouse wheel support for scrolling
;; (require 'mwheel)
;; (mouse-wheel-mode 1)

;; ; set command key to be meta instead of option
;; (if (system-is-mac)
;;     (setq ns-command-modifier 'meta))

;; ; number of characters until the fill column
;; (setq-default fill-column 70)

;; ; each line of text gets one line on the screen (i.e., text will run
;; ; off the left instead of wrapping around onto a new line)
;; (setq-default truncate-lines 1)
;; ; truncate lines even in partial-width windows
;; (setq truncate-partial-width-windows 1)

;; ; default window width and height
;; (defun custom-set-frame-size ()
;;   (add-to-list 'default-frame-alist '(height . 50))
;;   (add-to-list 'default-frame-alist '(width . 178)))
;; (custom-set-frame-size)
;; (add-hook 'before-make-frame-hook 'custom-set-frame-size)

;; ; window modifications
;; ;; (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
;; ;; (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
;; ;; (global-set-key (kbd "S-C-<down>") 'shrink-window)
;; ;; (global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; ; make end and home keys go to the start/end of buffers
;; (global-set-key (kbd "<end>") 'end-of-buffer)
;; (global-set-key (kbd "<home>") 'beginning-of-buffer)
;; (define-key input-decode-map "\e[1;5A" [C-up])
;; (define-key input-decode-map "\e[1;5B" [C-down])

;; ; always use spaces, not tabs, when indenting
;; (setq-default indent-tabs-mode nil)
;; ; indentation styles
;; (setq c-basic-offset 8)
;; (setq c-default-style (quote (
;;     (c-mode . "bsd")
;;     (java-mode . "java")
;;     (awk-mode . "awk")
;;     (other . "gnu"))))

;; ; ignore case when searching
;; (setq-default case-fold-search 1)

;; ; set the keybinding so that you can use f4 for goto line
;; (global-set-key [f4] 'goto-line)

;; ; require final newlines in files when they are saved
;; (setq require-final-newline 1)
;; ; add a new line when going to the next line
;; (setq next-line-add-newlines t)

;; ; show the current line and column numbers in the stats bar as well
;; (line-number-mode 1)
;; (column-number-mode 1)

;; ; don't blink the cursor
;; (blink-cursor-mode 0)

;; ; make sure transient mark mode is enabled (it should be by default,
;; ; but just in case)
;; (transient-mark-mode 1)

;; ; highlight parentheses when the cursor is next to them
;; (require 'paren)
;; (show-paren-mode 1)

;; ; text decoration
;; (require 'font-lock)
;; ;(setq font-lock-maximum-decoration 1)
;; (global-font-lock-mode 1)
;; (global-hi-lock-mode nil)
;; (setq jit-lock-contextually 1)
;; (setq jit-lock-stealth-verbose 1)

;; ; if there is size information associated with text, change the text
;; ; size to reflect it
;; (size-indication-mode 1)

;; ; disable backup
;; (setq backup-inhibited t)
;; ; disable auto save
;; (setq auto-save-default nil)

;; utf-8 powaa!!
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-input-method nil)
;; no annoying blinking cursor
(blink-cursor-mode -1)

;; automatically indent wherever I am
(global-set-key (kbd "RET") 'newline-and-indent)
;; set the random number seed from current time and pid
(random t)

;;---------;
;;  setq's ;
;;---------;

(setq locale-coding-system 'utf-8)
;; default fill column is 70, why?
(setq default-fill-column 79)
;; my sentences end with a dot, not with two spaces
(setq sentence-end-double-space nil);; kill the splash screen before its birth
(setq inhibit-splash-screen t)
;; but give the emacs window a still good shape !
(setq initial-frame-alist '((width . 90) (height . 45))) ; .Xdefaults

(setq auto-indent-on-visit-file t) ;; If you want auto-indent on for files
;; (setq linum-format "%4d \u2502") ;; theme

(setq linum-format "%4d ") ;; theme

(setq org-log-done 'note)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")

;; scrolling settings
;; (setq scroll-preserve-screen-position t)
;; (setq scroll-margin 2)
;; (setq scroll-step 1)


;;--------;
;;  hooks ;
;;--------;
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;-----------;
;;    Keys   ;
;;-----------;

(global-set-key (kbd "M-S-<left>") 'windmove-left)
(global-set-key (kbd "M-S-<right>") 'windmove-right)
(global-set-key (kbd "M-S-<up>") 'windmove-up)
(global-set-key (kbd "M-S-<down>") 'windmove-down)

(global-set-key (kbd "M-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-s-<down>") 'shrink-window)
(global-set-key (kbd "M-s-<up>") 'enlarge-window)

(global-set-key [C-return] 'sublime-new-line)
(global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)

(global-set-key (kbd "C-x w") 'elfeed)

;; (global-set-key (kbd "C-r") 'imenu)
;; (global-set-key (kbd "C-S-s") 'isearch-backward-regexp)

;; Guardar sesion
(desktop-save-mode 1)
;; memory
(setq gc-cons-threshold 20000000)
;; (global-aggressive-indent-mode 1)
;; (nyan-mode 1)



(provide 'general-settings)
