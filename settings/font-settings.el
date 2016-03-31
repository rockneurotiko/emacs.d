(defun font-exists-p (font)
  "check if font exists"
  (if (null (x-list-fonts font)) nil t))

(when (and (window-system) (font-exists-p "Fira Code"))
  (set-default-font "Fira Code")
  (set-frame-font "Fira Code 8")
  (set-face-attribute 'default nil :height 80 :family "Fira Code")
  (set-face-attribute 'default nil
                      :family "Fira Code"
                      :height 80
                      :weight 'normal
                      :width 'normal))


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
