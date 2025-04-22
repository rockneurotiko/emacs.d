(use-package nerd-icons
  :ensure t
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons marginalia vertico)
  :config
  (nerd-icons-completion-mode)
  ;; (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  :hook
  (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after (nerd-icons corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; (use-package nerd-icons-dired
;;   :ensure t
;;   :after nerd-icons
;;   :hook
;;   (dired-mode . nerd-icons-dired-mode))

(defun font-exists-p (font)
  "check if font exists"
  (if (null (x-list-fonts font)) nil t))

(defvar rock--fontname "0xProto Nerd Font Mono")
(defvar rock--fontname-variable "0xProto Nerd Font Mono")

;; (defvar rock--fontname "DejaVu Sans Mono")
;; (defvar rock--fontname-variable "DejaVu Sans Mono")
(defvar rock--fontsize 105)

(defun set-font-size ()
  (set-face-attribute 'default nil
                      :family rock--fontname
                      :height rock--fontsize
                      :weight 'normal
                      :width 'normal)

  (set-face-attribute 'fixed-pitch nil :family rock--fontname :height 1.0)
  (set-face-attribute 'variable-pitch nil :family rock--fontname-variable :height 1.0)

  (set-face-attribute 'mode-line nil :family rock--fontname :height 105)
  )


(defun set-interview-fontsize ()
  (interactive)
  (setq rock--fontsize 190)
  (set-font-size))

(defun set-default-fontsize ()
  (interactive)
  (setq rock--fontsize 105)
  (set-font-size))

(when (and (window-system) (font-exists-p rock--fontname))
  (set-frame-font rock--fontname)
  (set-default-fontsize))

;; (let ((fontname 'rock--fontname))
;;   )


;; (let ((fontname "Fira Code"))
;;   (when (and (window-system) (font-exists-p fontname))
;;   (set-frame-font fontname)
;;   (set-face-attribute 'default nil
;;                       :family fontname
;;                       :height 110
;;                       :weight 'normal
;;                       :width 'normal)))

;; In scratch execute this to list the fonts
;; (dolist (font (x-list-fonts "*"))
;;   (insert (format "%s\n" font)))


;; (let ((alist '((33 . ".\\(?:\\(?:==\\)\\|[!=]\\)")
;;                (35 . ".\\(?:[(?[_{]\\)")
;;                (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
;;                (42 . ".\\(?:\\(?:\\*\\*\\)\\|[*/]\\)")
;;                (43 . ".\\(?:\\(?:\\+\\+\\)\\|\\+\\)")
;;                (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;;                ;; (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=]\\)")
;;                (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
;;                (58 . ".\\(?:[:=]\\)")
;;                (59 . ".\\(?:;\\)")
;;                (60 . ".\\(?:\\(?:!--\\)\\|\\(?:\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[/<=>|-]\\)")
;;                (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
;;                (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;;                (63 . ".\\(?:[:=?]\\)")
;;                (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;;                (94 . ".\\(?:=\\)")
;;                (123 . ".\\(?:-\\)")
;;                (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
;;                (126 . ".\\(?:[=@~-]\\)")
;;                )
;;              ))
;;     (dolist (char-regexp alist)
;;         (set-char-table-range composition-function-table (car char-regexp)
;;                               `([,(cdr char-regexp) 0 font-shape-gstring]))))

(provide 'font-settings)
