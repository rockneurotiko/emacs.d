
(require 'multi-term)

(global-set-key (kbd "<f5>") 'multi-term)
(global-set-key (kbd "<C-next>") 'multi-term-next)
(global-set-key (kbd "<C-prior>") 'multi-term-prev)
(setq multi-term-buffer-name "term"
      multi-term-program "/bin/zsh")

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
              (autopair-mode -1)))


(add-hook 'term-mode-hook
          (lambda ()
              (define-key term-raw-map (kbd "C-y") 'term-paste)))


;; (defcustom term-unbind-key-list
;;     '("C-z" "C-x" "C-c" "C-h" "C-y" "<ESC>")
;;     "The key list that will need to be unbind."
;;     :type 'list
;;     :group 'multi-term)

;; (defcustom term-bind-key-alist
;;     '(
;;       ("C-c C-c" . term-interrupt-subjob)
;;       ("C-p" . previous-line)
;;       ("C-n" . next-line)
;;       ("C-s" . isearch-forward)
;;       ("C-r" . isearch-backward)
;;       ("C-m" . term-send-raw)
;;       ("M-f" . term-send-forward-word)
;;       ("M-b" . term-send-backward-word)
;;       ("M-o" . term-send-backspace)
;;       ("M-p" . term-send-up)
;;       ("M-n" . term-send-down)
;;       ("M-M" . term-send-forward-kill-word)
;;       ("M-N" . term-send-backward-kill-word)
;;       ("M-r" . term-send-reverse-search-history)
;;       ("M-," . term-send-input)
;;       ("M-." . comint-dynamic-complete))
;;     "The key alist that will need to be bind.
;; If you do not like default setup, modify it, with (KEY . COMMAND) format."
;;     :type 'alist
;;     :group 'multi-term)


;; (add-hook 'term-mode-hook
;;           (lambda ()
;;               (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
;;               (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))))


(provide 'term-settings)
