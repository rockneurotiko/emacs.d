;; THEMES! :-)
;; Functions to apply themes :)

(defun random-elt (choices)
    "Choose an element from a list at random."
    (elt choices (random (length choices))))

(use-package powerline
    :ensure t
    :config
    (powerline-default-theme))

(use-package moe-theme
  :ensure t
  :config
  (powerline-moe-theme)
  (moe-dark)
  (moe-theme-set-color 'magenta))

(use-package linum
    :ensure t
    :diminish linum-mode
  :init (setq linum-disabled-modes-list '(mu4e-headers-mode))
  :config
  (global-linum-mode 1)
  (defun linum-on ()
    (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
      (linum-mode 1))))

(defun set-powerline ()
    ;; (require 'powerline) ;; Yeah! line :)
    ;; (powerline-default-theme)
    )

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


;; Moe Worth!
(defun set-moe ()
  ;; (require 'moe-theme)
  ;; (powerline-moe-theme)
  ;; ;; (setq moe-theme-highlight-buffer-id nil)
  ;; (moe-dark)
  ;; (moe-theme-set-color 'magenta)
  ;; ;; (moe-theme-set-color 'purple)
  ;; ;; (moe-theme-random-color)
  )

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


(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 90
                    :weight 'normal
                    :width 'normal)

;; Instantly but if start maximized, then minimize
(toggle-frame-maximized)
;; Maximize at end
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))
(provide 'theme-settings)
