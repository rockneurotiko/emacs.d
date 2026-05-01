;;; anzu-fixes.el --- Fix anzu crash when buffer has no visible window -*- lexical-binding: t; -*-

;; Upstream bug: `anzu--search-outside-visible' and `anzu--check-minibuffer-input'
;; call `(with-selected-window (get-buffer-window buf) ...)' without guarding
;; against `get-buffer-window' returning nil.  This causes:
;;   (wrong-type-argument window-live-p nil)
;; when the buffer is not displayed in any window.
;;
;; Upstream: https://github.com/emacsorphanage/anzu (commit 21cb5ab, unfixed)
;; Remove this file once fixed upstream.

(defun anzu--search-outside-visible-fixed (buf input beg end use-regexp)
  "Like `anzu--search-outside-visible' but guards against nil window."
  (let* ((regexp (if use-regexp input (regexp-quote input)))
         (backward (> beg end))
         (searchfn (if backward #'re-search-backward #'re-search-forward)))
    (when (anzu--validate-regexp regexp)
      (when-let* ((win (get-buffer-window buf)))
        (with-selected-window win
          (goto-char beg)
          (when (funcall searchfn regexp end t)
            (setq anzu--outside-point (match-beginning 0))
            (let ((overlay-limit (anzu--overlay-limit backward)))
              (anzu--count-and-highlight-matched buf input beg end use-regexp
                                                 overlay-limit nil))))))))

(defun anzu--check-minibuffer-input-fixed (buf beg end use-regexp overlay-limit)
  "Like `anzu--check-minibuffer-input' but guards against nil window."
  (let* ((content (minibuffer-contents))
         (to (when (and (string-match (anzu--separator) content)
                        (get-text-property (match-beginning 0) 'separator content))
               (substring-no-properties content (match-end 0))))
         (from (or (and to (substring-no-properties content 0 (match-beginning 0)))
                   content))
         (empty-p (string= from ""))
         (overlayed (if empty-p
                        (setq anzu--cached-count 0)
                      (anzu--count-and-highlight-matched buf from beg end use-regexp
                                                         overlay-limit nil))))
    (when anzu--outside-point
      (setq anzu--outside-point nil)
      (when-let* ((win (get-buffer-window buf)))
        (with-selected-window win
          (goto-char beg))))
    (when (and (not empty-p) (zerop overlayed))
      (anzu--search-outside-visible buf from beg end use-regexp))
    (when to
      (setq anzu--last-replace-input "")
      (anzu--append-replaced-string to buf beg end use-regexp overlay-limit from))
    (setq anzu--total-matched anzu--cached-count)
    (force-mode-line-update)))

(advice-add 'anzu--search-outside-visible :override #'anzu--search-outside-visible-fixed)
(advice-add 'anzu--check-minibuffer-input :override #'anzu--check-minibuffer-input-fixed)

(provide 'anzu-fixes)
;;; anzu-fixes.el ends here
