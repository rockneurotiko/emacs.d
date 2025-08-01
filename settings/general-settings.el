;; -*- lexical-binding: t; -*-

                                        ;--------------------------------;
;;; General or Global Settings ;;;
;--------------------------------;

;; set PATH, because we don't load .bashrc
;; function from https://gist.github.com/jakemcc/3887459
(defun set-exec-path-from-shell-PATH ()
  ;; ;; (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
  ;; (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo -n $PATH'")))
  ;;   (setenv "PATH" path-from-shell)
  ;;   (setq exec-path (split-string path-from-shell path-separator)))

  ;; FISH hack
  (let*
      ((fish-path (shell-command-to-string "$SHELL -c 'echo -n $PATH'"))
       (path-parts (split-string fish-path " "))
       (path-string (string-join path-parts ":")))
    (setenv "PATH" path-string)
    (setq exec-path path-parts)))


(set-exec-path-from-shell-PATH)
(setenv "PATH" (concat "~/.local/bin:" "/usr/local/bin:" (getenv "PATH")))

;; Node 20 for copilot
(setenv "PATH" (concat "~/.local/share/mise/installs/node/23.11.0/bin" (getenv "PATH")))

;; No bars pls
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Name
(setq user-full-name "Rock Neurotiko"
      user-mail-address (concat "miguelglafuente" "@" "gmail" ".com"))

;; cool frame title with currently edited buffer name
(setq frame-title-format
      (concat "%b - " invocation-name "@" system-name))

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
(setq default-fill-column 80)
;; my sentences end with a dot, not with two spaces
(setq sentence-end-double-space nil);; kill the splash screen before its birth
(setq inhibit-splash-screen t)
;; but give the emacs window a still good shape !
;; (setq initial-frame-alist '((width . 90) (height . 45))) ; .Xdefaults

(setq-default indent-tabs-mode nil)
(setq org-log-done 'note)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")

(setq custom-file "~/.emacs.d/settings/custom-variables.el")
;; (load custom-file)

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

;; (global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)
;; (global-set-key (kbd "C-S-s") 'isearch-backward-regexp)
(global-set-key [f4] 'goto-line)

;; Functions from rock-defuns.el
(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)
(global-set-key [C-return] 'sublime-new-line)
(global-set-key (kbd "C-c C") 'w0w-calculator)

;;-------------;
;;Other things!;
;;-------------;

;; Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Save historial
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))


(defalias 'yes-or-no-p 'y-or-n-p)
;; ; turn on mouse wheel support for scrolling
(require 'mwheel)
(mouse-wheel-mode 1)

(transient-mark-mode 1)
;; Guardar sesion
(desktop-save-mode 1)
;; memory
(setq gc-cons-threshold 20000000)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "xdg-open")

;; (setq browse-url-browser-function 'browse-url-firefox
;;       browse-url-new-window-flag  t
;;       browse-url-firefox-new-window-is-tab t)

;; (setq browse-url-browser-function 'browse-url-generic)
;; (setq browse-url-generic-program "firefox")

(setq sentence-end-double-space nil)

;; winner-mode https://www.emacswiki.org/emacs/WinnerMode
(winner-mode 1)

(setq calendar-latitude 40.1)
(setq calendar-longitude 3)
(setq calendar-location-name "Pozuelo de Alarcon")

;; Line numbers

(global-display-line-numbers-mode 1)
(setq display-line-numbers 'absolute)

;; Mute ding sound
(setq visible-bell 1)

;; Visit true name on symlinks
(setq find-file-visit-truename t)

;; dead keys
(define-key key-translation-map [dead-grave] "`")
(define-key key-translation-map [dead-acute] "'")
(define-key key-translation-map [dead-circumflex] "^")
(define-key key-translation-map [dead-diaeresis] "\"")
(define-key key-translation-map [S-dead-diaeresis] "\"")
(define-key key-translation-map [dead-tilde] "~")

;; Rotate window
(use-package window
  :bind
  ("C-x C-0" . rotate-windows-back)
  ("C-x C-1" . rotate-windows)
  ("C-x C-2" . flip-window-layout-vertically)
  ("C-x C-3" . flip-window-layout-horizontally)
  ("C-x C-4" . transpose-window-layout))

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)


;; macOS config
(if (system-is-mac)
    (progn
       (setq mac-command-key-is-meta t)
       (setq mac-command-modifier 'meta)
       (setq mac-option-key-is-meta nil)
       (setq mac-option-modifier 'super)
       (setq x-select-enable-clipboard t)
       (setq ring-bell-function 'ignore)
       (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
       (add-to-list 'exec-path "/usr/local/bin")
       (message "Loaded macOS config.")))


;; Hack for wayland copy-paste
(setq wl-copy-process nil)
(setq wl-last-copied nil)
(defun wl-copy (text)
  (if (not (process-live-p wl-copy-process))
      (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-o" "-f" "-n")
                                      ;; :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe
                                      :noquery t)))

  (setq wl-last-copied text)
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))




;; (defun wl-delete-last ()
;;   ;; (call-process-shell-command "cliphist list | head -n 1 | cliphist delete &" nil 0)
;;   )

;; (defun wl-paste ()
;;   (let ((cliphist-value (shell-command-to-string "cliphist list | head -n 1 | cliphist decode")))
;;     (unless (string= cliphist-value wl-last-copied)
;;         cliphist-value)))

(defun wl-paste ()
  (let ((cliphist-value (shell-command-to-string "wl-paste -n")))
    (unless (string= cliphist-value wl-last-copied)
        cliphist-value)
    ))

(defun clipse-copy (text)
  (if (not (process-live-p wl-copy-process))
      (setq wl-copy-process (make-process :name "clipse"
                                      :buffer nil
                                      :command '("clipse" "-c")
                                      ;; :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe
                                      :noquery t)))

  (setq wl-last-copied text)
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process)
  )

;; (defun clipse ()
;;   (let ((paste-value (shell-command-to-string "clipse -p")))
;;     (unless (string= paste-value wl-last-copied)
;;         paste-value)))

;; (setq interprogram-cut-function 'wl-copy)
;; (setq interprogram-paste-function 'wl-paste)
;; (setq interprogram-cut-function 'clipse-copy)

;; (setq interprogram-paste-function nil)

(defun set-interprogram-paste-wl-paste ()
  (interactive)
  (setq interprogram-paste-function 'wl-paste))

(defun set-interprogram-paste-nil ()
  (interactive)
  (setq interprogram-paste-function nil))

(defun set-interprogram-cut-clipse ()
  (interactive)
  (setq interprogram-cut-function 'clipse-copy))

(defun set-interprogram-cut-wl-copy ()
  (interactive)
  (setq interprogram-cut-function 'wl-copy))

(defun set-interprogram-cut-nil ()
  (interactive)
  (setq interprogram-cut-function nil))

;; (setq interprogram-paste-function 'clipse)

;; (use-package xclip
;;   :ensure t
;;   :setopt
;;   (xclip-program "wl-copy")
;;   (xclip-select-enable-clipboard t)
;;   (xclip-mode t)
;;   (xclip-method 'wl-copy))

;; GC

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(setq gc-cons-threshold most-positive-fixnum)

(run-with-idle-timer 1.2 t 'garbage-collect)



(provide 'general-settings)
