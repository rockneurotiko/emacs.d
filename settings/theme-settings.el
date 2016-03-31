;; THEMES! :-)
;; Functions to apply themes :)

(defun random-elt (choices)
  "Choose an element from a list at random."
  (elt choices (random (length choices))))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package linum
  :ensure t
  :diminish linum-mode
  :init (setq linum-disabled-modes-list '(mu4e-headers-mode))
  :config
  (global-linum-mode 1)
  (defun linum-on ()
    (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
      (linum-mode 1))))

(use-package linum-relative
  :ensure t
  :diminish linum-relative-mode
  :config
  (linum-relative-global-mode))

;; (defun set-powerline ()
;;   ;; (require 'powerline) ;; Yeah! line :)
;;   ;; (powerline-default-theme)
;;   )

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

(defun set-linum ()
  ;; Numero de lineas
  ;; (require 'linum)
  ;; (global-linum-mode 1)
  ;; (setq linum-disabled-modes-list '(mu4e-headers-mode))
  ;; (defun linum-on ()
  ;;     (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
  ;;         (linum-mode 1)))
  )

;; Instantly but if start maximized, then minimize
(toggle-frame-maximized)
;; Maximize at end
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))
(provide 'theme-settings)
