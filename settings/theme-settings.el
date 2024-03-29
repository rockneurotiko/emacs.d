;; THEMES! :-)
;; Functions to apply themes :)

(defun random-elt (choices)
  "Choose an element from a list at random."
  (elt choices (random (length choices))))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(defun set-random-theme ()
  ;; Select one random from:
  ;; [spolsky, granger, cyberpunk, ample, grandshell, monokai, sanityinc-tomorrow-night, sanityinc-tomorrow-eighties]
  (load-theme
   (random-elt
    '(spolsky
      granger
      cyberpunk
      ample
      grandshell
      monokai
      sanityinc-tomorrow-night
      sanityinc-tomorrow-eighties)) t))


(defun set-darkokai ()
  (use-package darkokai-theme
    :ensure t
    :config (load-theme 'darkokai t)))

(defun set-cyberpunk ()
  (use-package cyberpunk-theme
    :ensure t
    :config (load-theme 'cyberpunk t)))

(defun set-sanityinc ()
  (use-package color-theme-sanityinc-tomorrow
    :ensure t
    :config
    (color-theme-sanityinc-tomorrow-eighties)))

;; Moe Worth!
(defun set-moe ()
  (use-package moe-theme
  :ensure t
  :config
  (powerline-moe-theme)
  (moe-dark)
  (moe-theme-set-color 'magenta)))

(defun set-full-paren ()
  (show-paren-mode t)
  (setq show-paren-style 'expression))

;; Instantly but if start maximized, then minimize
(toggle-frame-maximized)
;; Maximize at end
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))
(provide 'theme-settings)
