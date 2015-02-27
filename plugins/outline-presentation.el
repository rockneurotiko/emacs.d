;; outline-presentation-mode by p4bl0, under GPL v3+
;; forked from http://uzy.me/j6 by Craig Andera

(eval-when-compile
  (require 'outline))

;; Enable narrowing, which is disabled by default
(put 'narrow-to-region 'disabled nil)

(defvar outline-presentation-mode nil
  "Outline presentation minor mode.")

(defvar outline-presentation-mode-map nil
  "Keymap for outline presentation mode")

(defvar outline-presentation-previous-points nil
  "History of point position before jumping to toc")

(defvar outline-presentation-slides-count nil
  "Number of slides in the presentation")

(defvar outline-presentation-current-slide-number nil
  "The number of the current slide")

(defvar outline-presentation-mode-hook nil
  "Hooks")

(unless outline-presentation-mode-map
  (setq outline-presentation-mode-map (make-sparse-keymap))
  (define-key outline-presentation-mode-map (kbd "A-M-n")
    'outline-presentation-next)
  (define-key outline-presentation-mode-map (kbd "A-M-p")
    'outline-presentation-previous)
  (define-key outline-presentation-mode-map (kbd "A-M-f")
    'outline-presentation-next-top)
  (define-key outline-presentation-mode-map (kbd "A-M-b")
    'outline-presentation-previous-top)
  (define-key outline-presentation-mode-map (kbd "A-M-t")
    'outline-presentation-top-toc)
  (define-key outline-presentation-mode-map (kbd "A-M-y")
    'outline-presentation-toc)
  (define-key outline-presentation-mode-map (kbd "A-M-r")
    'outline-presentation-resume)
  (define-key outline-presentation-mode-map (kbd "A-M-s")
    'outline-presentation-start)
  (define-key outline-presentation-mode-map (kbd "A-M-a")
    'outline-presentation-first)
  (define-key outline-presentation-mode-map (kbd "A-M-q")
    'outline-presentation-mode-off))

(defun outline-presentation-mode (&optional enable)
  "With no arguments, toggles outline-presentation minor mode.
  With a positive argument, turns outline-presentation minor mode
  on. With a negative argument, turns outline-presentation minor
  mode off."
  (interactive "P")
  (setq outline-presentation-mode
        (if (null enable)
            (not outline-presentation-mode)
            (> (prefix-numeric-value enable) 0)))
  (if outline-presentation-mode
      (progn
        (outline-mode)
        (set (make-local-variable 'outline-presentation-previous-points) nil)
        (set (make-local-variable 'outline-presentation-slides-count)
             (outline-presentation-count-headings))
        (set (make-local-variable 'outline-presentation-current-slide-number)
             (outline-presentation-current-slide))
        (set (make-local-variable 'mode-line-position)
             (cons (list '(:eval (outline-presentation-position)))
                   mode-line-position))
        (if (not (assq 'outline-presentation-mode minor-mode-alist))
            (setq minor-mode-alist
                  (cons '(outline-presentation-mode " Presentation")
                        minor-mode-alist)))
        (use-local-map outline-presentation-mode-map)
        (run-hooks 'outline-presentation-mode-hook)
        (outline-presentation-start))
      (progn
        (use-local-map nil)
        (outline-presentation-end)
        (outline-mode))))

(defun outline-presentation-mode-on ()
  "Turns on outline-presentation-mode"
  (interactive)
  (outline-presentation-mode 1))

(defun outline-presentation-mode-off ()
  "Turns off outline-presentation-mode"
  (interactive)
  (outline-presentation-mode -1))

(defun outline-presentation-end ()
  "Ends the presentation"
  (widen)
  (show-all))

(defun outline-presentation-count-headings ()
  "Returns the number of slides"
  (save-excursion
    (goto-char (point-min))
    (let ((count -1)
          (previous -1))
      (while (not (= previous (point)))
        (setq previous (point))
        (if (<= (outline~level) 3)
            (setq count (1+ count)))
        (outline-next-heading))
      count)))

(defun outline-presentation-goto-next-slide ()
  "Moves to the next slide"
  (let ((previous (point)))
    (outline-next-heading)
    (while (and (> (outline~level) 3)
                (not (= previous (point))))
      (setq previous (point))
      (outline-next-heading))))

(defun outline-presentation-goto-previous-slide ()
  "Moves to the previous slide"
  (let ((previous (point)))
    (outline-previous-heading)
    (while (and (> (outline~level) 3)
                (not (= previous (point))))
      (setq previous (point))
      (outline-previous-heading))))

(defun outline-presentation-current-slide ()
  "Returns the number of the current slide"
  (save-excursion
    (outline-back-to-heading)
    (let ((number 0)
          (previous -1))
      (while (not (= previous (point)))
        (setq number (1+ number)
              previous (point))
        (outline-presentation-goto-previous-slide))
      number)))

(defun outline-presentation-position ()
  "Returns a string with the position in the presentation for the modeline"
  (save-excursion
    (if (< outline-presentation-current-slide-number 0)
        "ToC "
      (concat
       (number-to-string outline-presentation-current-slide-number)
       "/"
       (number-to-string outline-presentation-slides-count)
       " "))))

(defun outline-presentation-on-top-heading ()
  "Returns t if the current heading is top level, nil otherwise"
  (interactive)
  (save-excursion
    (outline-back-to-heading t)
    (or (= (outline~level) 1)
        (let ((pos (point)))
          (outline-up-heading 1 t)
          (= pos (point))))))

(defun outline-presentation-top-toc ()
  "Shows only the top headings"
  (interactive)
  (widen)
  (show-all)
  (setq outline-presentation-previous-points
        (cons (point) outline-presentation-previous-points)
        outline-presentation-current-slide-number -1)
  (hide-sublevels 1)
  (goto-char (point-min)))

(defun outline-presentation-toc ()
  "Shows only the headings"
  (interactive)
  (widen)
  (show-all)
  (setq outline-presentation-previous-points
        (cons (point) outline-presentation-previous-points)
        outline-presentation-current-slide-number -1)
  (hide-body)
  (hide-sublevels 3)
  (goto-char (point-min)))

(defun outline-presentation-resume ()
  "Resumes the presentation if stopped for toc"
  (interactive)
  (unless (null outline-presentation-previous-points)
    (widen)
    (show-all)
    (goto-char (car outline-presentation-previous-points))
    (setq outline-presentation-previous-points
          (cdr outline-presentation-previous-points))
    (outline-presentation-current)))

(defun outline-presentation-show-slide ()
  "Narrows to the current heading and its body"
  (let ((start (point)))
    (outline-presentation-goto-next-slide)
    (narrow-to-region start (point))
    (goto-char start)
    (show-entry)))

(defun outline-presentation-show-toc ()
  "Narrows to show only the headings of the current section"
  (let ((start (point)))
    (condition-case nil
        (outline-forward-same-level 1)
      (error (goto-char (point-max))))
    (let ((end (point)))
      (while (not (= start (point)))
        (backward-char)
        (outline-back-to-heading t)
        (let ((lvl (outline~level)))
          (when (or (= lvl 2) (= lvl 3))
          (hide-subtree))))
    (narrow-to-region start end)
    (goto-char start))))

(defun outline-presentation-show ()
  "Chooses show mode between slide and toc"
  (setq outline-presentation-current-slide-number
        (outline-presentation-current-slide))
  (outline-back-to-heading)
  (if (= (outline~level) 1)
      (outline-presentation-show-toc)
    (outline-presentation-show-slide)))

(defun outline-presentation-next ()
  "Makes the next outline node the only visible node"
  (interactive)
  (widen)
  (show-all)
  (outline-back-to-heading t)
  (outline-presentation-goto-next-slide)
  (outline-presentation-show))

(defun outline-presentation-next-top ()
  "Makes the next top outline node the only visible node"
  (interactive)
  (widen)
  (show-all)
  (outline-back-to-heading t)
  (progn
    (while (not (outline-presentation-on-top-heading))
      (outline-up-heading 1 t))
    (condition-case nil
        (outline-forward-same-level 1)
      (error nil)))
  (outline-presentation-show))

(defun outline-presentation-previous ()
  "Makes the previous outline node the only visible node"
  (interactive)
  (widen)
  (show-all)
  (outline-back-to-heading t)
  (outline-presentation-goto-previous-slide)
  (outline-presentation-show))

(defun outline-presentation-previous-top ()
  "Makes the previous top outline node the only visible node"
  (interactive)
  (widen)
  (show-all)
  (outline-back-to-heading t)
  (progn
    (while (not (outline-presentation-on-top-heading))
      (outline-up-heading 1 t))
    (condition-case nil
        (outline-backward-same-level 1)
      (error nil)))
  (outline-presentation-show))

(defun outline-presentation-first ()
  "Goes back to the first slide"
  (interactive)
  (widen)
  (show-all)
  (goto-char (point-min))
  (outline-presentation-show))

(defun outline-presentation-current ()
  "Makes the current (where the point is) outline node the only visible node"
  (interactive)
  (widen)
  (show-all)
  (outline-back-to-heading t)
  (while (> (outline~level) 3)
    (previous-line)
    (outline-back-to-heading t))
  (outline-presentation-show))

(defun outline-presentation-start ()
  "Begin the presentation by making only the current node visible"
  (interactive)
  (use-local-map outline-presentation-mode-map)
  (outline-presentation-current))

;; fix by reimplementing outline-level which is broken in recent Emacs versions…
(defun outline~level ()
  "Returns the level of a outline header"
  (save-excursion
    (outline-back-to-heading t)
    (string-match outline-regexp (thing-at-point 'line))
    (- (match-end 0) (match-beginning 0))))

(provide 'outline-presentation)
