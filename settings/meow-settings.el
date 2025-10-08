;; -*- lexical-binding: t;-*-

(use-package meow
  :ensure t
  :init
  (defun rock--meow-duplicate ()
    "Duplicate region if active. Otherwise duplicate char at point"
    (interactive)
    (if (region-active-p)
        (progn
          (meow-save)
          (meow-yank))
      (progn
        (meow-save-char)
        (meow-yank))))

  (defun rock--meow-duplicate-and-comment ()
    "Duplicate region and then comment region"
    (interactive)
    (if (region-active-p)
        (progn
          (meow-save)
          (meow-yank)
          (comment-or-uncomment-region
           (region-beginning)
           (region-end)))))

  :config
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-dvorak)
  (meow-leader-define-key
   '("b" . "C-x b")
   '("f" . "C-x C-f")
   '("o" . "C-x o")
   '("0" . "C-x 0")
   '("1" . "C-x 1")
   '("2" . "C-x 2")
   '("3" . "C-x 3")
   ;; Revisit if I need to execute N times commands
   ;; '("1" . meow-digit-argument)
   ;; '("2" . meow-digit-argument)
   ;; '("3" . meow-digit-argument)
   ;; '("4" . meow-digit-argument)
   ;; '("5" . meow-digit-argument)
   ;; '("6" . meow-digit-argument)
   ;; '("7" . meow-digit-argument)
   ;; '("8" . meow-digit-argument)
   ;; '("9" . meow-digit-argument)
   ;; '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-motion-overwrite-define-key
   ;; custom keybinding for motion state
   ;; '("n" . meow-next)
   ;; '("p" . meow-prev)
   '("<escape>" . ignore))


  ;; Expansino
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   ;; '("-" . negative-argument)
   '(";" . meow-reverse))

  (meow-normal-define-key
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("<" . meow-beginning-of-thing)
   '(">" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-line)
   '("E" . meow-goto-line)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("l" . meow-till)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-prev)
   '("P" . meow-prev-expand)
   '("q" . meow-quit)
   ;; '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-search)
   '("t" . meow-right)
   '("T" . meow-right-expand)
   '("u" . meow-pop-selection)
   ;; '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-save)
   '("X" . meow-sync-grab)
   '("y" . meow-yank)
   '("z" . meow-undo)
   '("Z" . meow-undo-in-selection)
   '("'" . repeat)
   '("/" . rock--meow-duplicate)
   '("?" . rock--meow-duplicate-and-comment)
   '("<escape>" . ignore))
  (meow-global-mode 1)
  (setq meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-iso)

  (setq meow-command-to-short-name-list
      (append meow-command-to-short-name-list
              '(;; (nt-bounds-str . "[str]")
                ;; (nt-inner-str . "←str→")
                ;; (nt-insert-at-cursor . "ins.")
                ;; (nt-negative-find . "←find")
                ;; (nt-paragraph . "[para]")
                ;; (nt-subtract-one . "-1")
                ;; (nt-toggle-case-dwiam . "case")
                (rock--meow-duplicate . "dup")
                (rock--meow-duplicate-and-comment . "dup+com")
                ))))

(use-package meow-tree-sitter
     :ensure t
     :config
     (meow-tree-sitter-register-defaults))

(provide 'meow-settings)
