;-------------------;
;;; Markdown mode ;;;
;-------------------;

(package-require 'markdown-mode)
(require 'markdown-mode)

(setq-default markdown-command "pandoc -S -s --self-contained -f markdown -t html5")

(add-to-list 'auto-mode-alist '("\\.text\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))

;; I have to do this because of fucking MD mode xD
(define-key markdown-mode-map (kbd "M-S-<left>") nil)
(define-key markdown-mode-map (kbd "M-S-<right>") nil)
(define-key markdown-mode-map (kbd "M-S-<down>") nil)
(define-key markdown-mode-map (kbd "M-S-<up>") nil)

(load "~/.emacs.d/plugins/emacs-livedown/livedown.el")
(require 'livedown)

(provide 'markdown-settings)
