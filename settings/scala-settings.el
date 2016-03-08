(defun eval-scala (start end)
  (interactive (list (point) (mark)))
  ;; start scala if it hasn't started yet
  (unless (get-process "scala-repl")
    (let ((process-connection-type nil))  ; use a pipe
      (start-process "scala-repl" "*scala*"  "scala"))
    (set-buffer "*scala*")
    (special-mode))
  ;; execute
  (process-send-region "scala-repl" start end)
  (process-send-string "scala-repl" "\n")
  ;;display buffer
  (display-buffer
   (get-buffer "*scala*")
   '((display-buffer-reuse-window
      display-buffer-pop-up-window
      display-buffer-pop-up-frame)
     (reusable-frames . 0)
     (window-height . 8) (window-width . nil))))

(use-package scala-mode2
  :ensure t)

(use-package ensime
  :ensure t
  :config
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
  :bind ("C-c C-e" . eval-scala))

(provide 'scala-settings)
