;; -*- lexical-binding: t; -*-

(straight-use-package
 '(eat :type git
       :host codeberg
       :repo "akib/emacs-eat"
       :files ("*.el" ("term" "term/*.el") "*.texi"
               "*.ti" ("terminfo/e" "terminfo/e/*")
               ("terminfo/65" "terminfo/65/*")
               ("integration" "integration/*")
               (:exclude ".dir-locals.el" "*-tests.el"))))

(use-package multi-term
  :ensure t
  :init
  (setq multi-term-buffer-name "term"
        multi-term-program "/bin/zsh")
  :bind (("<f5>" . multi-term)
         ("<C-next>" . multi-term-next)
         ("<C-prior>" . multi-term-prev))
  :config
  (when (require 'term nil t) ; only if term can be loaded..
    (setq term-bind-key-alist
          (list (cons "C-c C-c" 'term-interrupt-subjob)
                (cons "C-p" 'previous-line)
                (cons "C-n" 'next-line)
                (cons "M-f" 'term-send-forward-word)
                (cons "M-b" 'term-send-backward-word)
                (cons "C-c C-j" 'term-line-mode)
                (cons "C-c C-k" 'term-char-mode)
                (cons "M-DEL" 'term-send-backward-kill-word)
                (cons "M-d" 'term-send-forward-kill-word)
                (cons "<C-left>" 'term-send-backward-word)
                (cons "<C-right>" 'term-send-forward-word)
                (cons "C-r" 'term-send-reverse-search-history)
                (cons "M-p" 'term-send-raw-meta)
                (cons "M-y" 'term-send-raw-meta)
                (cons "C-y" 'term-send-raw))))
  (add-hook 'term-mode-hook
            (lambda ()
              (setq term-buffer-maximum-size 10000)))
  (add-hook 'term-mode-hook
            (lambda ()
	      (setq show-trailing-whitespace nil)
	      (when (featurep 'autopair-mode)
		(autopair-mode -1))))
  (add-hook 'term-mode-hook
            (lambda ()
              (define-key term-raw-map (kbd "C-y") 'term-paste))))


;; (defun emux-default-sessions ()
;;   (emux-session-define-template
;;    system
;;    (emux-session-set-default-directory "~/")
;;    (emux-screen-create '(:name "system"))
;;    ;; (emux-term "bmon")
;;    ;; (emux-term "free space" "watch df -h")
;;    (other-window 1)
;;    (proced)
;;    (other-window 1)
;;    (delete-window)))


;; (defun set-emux ()
;;   (add-to-list 'load-path "~/.emacs.d/plugins/emux")
;;   (package-require 'emux-session)
;;   (global-set-key (kbd "C-x c") 'emux-term-create)
;;   (global-set-key (kbd "C-x P") 'emux-session-load-template)
;;   (global-set-key (kbd "M-s s") 'emux-screen-switch)
;;   (global-set-key (kbd "M-s S") 'emux-session-switch)
;;   (setq term-bind-key-alist
;;         '(("C-x c" . emux-term-create)
;;           ("C-x r" . emux-term-rename)
;;           ("C-x K" . emux-term-destroy)
;;           ("C-x C" . emux-screen-create)
;;           ("C-x R" . emux-screen-rename)
;;           ("M-s s" . emux-screen-switch)
;;           ("C-x M-s" . emux-jump-to-screen)
;;           ("M-s S" . emux-session-switch)
;;           ("C-x P" . emux-session-load-template)
;;           ("C-x C-S-k" . emux-session-destroy)
;;           ("C-x B" . emux-jump-to-buffer)
;;           ("C-S-y" . emux-term-yank)
;;           ("C-x -" . emux-term-vsplit)
;;           ("C-x |" . emux-term-hsplit)
;;           ("C-c C-c" . term-interrupt-subjob)
;;           ("C-S-c" . term-interrupt-subjob)
;;           ("C-S-p" . previous-line)
;;           ("C-S-s" . isearch-forward)
;;           ("C-S-r" . isearch-backward)
;;           ("C-m" . term-send-raw)
;;           ("M-f" . term-send-forward-word)
;;           ("M-b" . term-send-backward-word)
;;           ("M-o" . term-send-backspace)
;;           ("M-d" . term-send-forward-kill-word)
;;           ("M-DEL" . term-send-backward-kill-word)
;;           ("M-," . term-send-input)
;;           ("M-." . comint-dynamic-complete)))

;;   (define-key term-mode-map (kbd "C-S-l") 'emux-term-clear-screen)

;;   (custom-set-variables
;;    '(emux-completing-read-command (quote ido-completing-read))
;;    '(emux-term-program "/usr/bin/zsh")
;;    '(term-unbind-key-list (quote ("C-z" "C-x" "C-c" "C-h" "C-l" "<ESC>")))
;;    ;; '(ansi-term-color-vector [unspecified "white" "red" "green" "yellow" "royal blue" "magenta" "cyan" "white"] t)
;;    '(multi-term-scroll-show-maximum-output t)
;;    '(term-buffer-maximum-size 16384)))

(provide 'term-settings)
