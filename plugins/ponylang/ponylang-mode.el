(defvar pony-mode-hook nil)

(defvar pony-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" newline-and-indent)
    map)
  "Keymap for Pony major mode")

(add-to-list 'auto-mode-alist '("\\.pony\\'" . ponylang-mode))
