;; THEMES! :-)
;; Functions to apply themes :)

(defun random-elt (choices)
  "Choose an element from a list at random."
  (elt choices (random (length choices))))

(defun poweline ()
    (use-package powerline
      :ensure t
      :config
      (powerline-default-theme)))

(defun set-modeline ()
  ;; (use-package smart-mode-line
  ;;   :ensure t
  ;;   :config
  ;;   (sml/setup))

  ;; (setq rm-blacklist
  ;;       (format "^ \\(%s\\)$"
  ;;               (mapconcat #'identity
  ;;                          '("ARev"     ;Auto revert
  ;;                            "SP"       ;Smart parens
  ;;                            "FlyC.*"   ;Flycheck
  ;;                            "WK"       ;Whichkey
  ;;                            "Projectile.*" ;
  ;;                            "GitGutter"
  ;;                            "Helm")
  ;;                          "\\|")))

  ;; (use-package doom-modeline
  ;;   :ensure t
  ;;   :hook (after-init . doom-modeline-mode)
  ;;   :config (setq doom-modeline-buffer-file-name-style 'relative-to-project
  ;;                 doom-modeline-major-mode-color-icon t
  ;;                 doom-modeline-height 20))
  )

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

;; (defun use-linum ()
;;   (use-package linum
;;     :ensure t
;;     :disabled t
;;     :diminish linum-mode
;;     :init (setq linum-disabled-modes-list '(mu4e-headers-mode))
;;     :config
;;     (global-linum-mode)
;;     (defun linum-on ()
;;       (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
;;         (linum-mode 1))))

;;   (use-package linum-relative
;;     :ensure t
;;     :disabled t
;;     :diminish linum-relative-mode
;;     :config
;;     (linum-relative-global-mode))
;;   )

(defun set-line-numbers ()
  (when (version<= "26.0.50" emacs-version) (global-display-line-numbers-mode))
  ;; Numero de lineas
  ;; (use-linum)
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
