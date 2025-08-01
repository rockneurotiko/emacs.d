
;;---------------;
;;; yasnippet ;;;
;;---------------;
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (add-to-list 'load-path "~/.emacs.d/snippets")
  ;; (require 'es6-snippets)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
  (yas-global-mode 1))


(provide 'yasnippet-settings)
;;; yasnippet-settings.el ends here
