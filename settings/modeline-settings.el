;;; modeline-settings.el --- Mode-line backend, with a live toggle -*- lexical-binding: t; -*-

;;; Commentary:

;; Two mode-line packages are configured here:
;;
;;   sleek-modeline  actively maintained, the default.
;;   mood-line       dormant upstream since 2023-12-10, kept as a fallback.
;;
;; Both packages are loaded and fully configured at startup, but neither
;; calls its own `-mode' entry point directly.  `rock/modeline-set' turns
;; one on and the other off; `rock/modeline-toggle' flips between them
;; on the fly, e.g. to compare the two or fall back if sleek-modeline ever
;; breaks.  `rock/modeline-backend' picks which one starts active.

;;; Code:

(defcustom rock/modeline-backend 'sleek-modeline
  "Which mode-line package is active.
One of `sleek-modeline' (maintained) or `mood-line' (dormant upstream,
kept as a fallback).  Set this to change the default at startup, or call
`rock/modeline-toggle'/`rock/modeline-set' to switch live."
  :type '(choice (const :tag "sleek-modeline (maintained)" sleek-modeline)
                 (const :tag "mood-line (dormant upstream, fallback)" mood-line))
  :group 'rock)

;; --------------------------------------------------------------------------
;; breadcrumb -- only pulled in for mood-line's project-crumbs segment below
;; --------------------------------------------------------------------------

(use-package breadcrumb
  :ensure (breadcrumb :host github :repo "joaotavora/breadcrumb"))

;; --------------------------------------------------------------------------
;; mood-line -- dormant upstream since 2023-12-10, kept as a fallback
;; --------------------------------------------------------------------------

(use-package mood-line
  :ensure t
  :after (breadcrumb)
  :init
  ;; Replace the plain buffer-name segment with breadcrumb's project crumbs
  ;; (project-relative path to the current file), falling back to the buffer
  ;; name for non-file buffers. Defined in :init so the format constant exists
  ;; before :custom runs.
  (defun rock/mood-line-segment-breadcrumb ()
    "Display `breadcrumb-project-crumbs' as a mood-line segment."
    (let ((crumbs (and (fboundp 'breadcrumb-project-crumbs)
                       (ignore-errors (breadcrumb-project-crumbs)))))
      (if (and crumbs (not (string-empty-p crumbs)))
          crumbs
        (format-mode-line "%b" 'mood-line-buffer-name))))

  (with-eval-after-load 'mood-line
    (defconst rock/mood-line-format-breadcrumb
      (mood-line-defformat
       :left
       (((mood-line-segment-modal)                  . " ")
        ((or (mood-line-segment-buffer-status) " ") . " ")
        ((rock/mood-line-segment-breadcrumb)        . "  ")
        ((mood-line-segment-anzu)                   . "  ")
        ((mood-line-segment-multiple-cursors)       . "  ")
        ((mood-line-segment-cursor-position)        . " ")
        (mood-line-segment-scroll))
       :right
       (((mood-line-segment-vc)         . "  ")
        ((mood-line-segment-major-mode) . "  ")
        ((mood-line-segment-misc-info)  . "  ")
        ((mood-line-segment-checker)    . "  ")
        ((mood-line-segment-process)    . "  ")))
      "Mood-line format that swaps the buffer-name segment for breadcrumb crumbs.")
    (setq mood-line-format rock/mood-line-format-breadcrumb))

  :config
  ;; `rock/modeline-set' calls `mood-line-mode' itself; it is not turned on
  ;; here so that loading this package never overrides whichever backend is
  ;; currently selected.

  ;; Workaround for an upstream mood-line load-order bug.
  ;;
  ;; `mood-line.el' defines one-shot lazy stubs (`mood-line--deflazy') for its
  ;; checker and vc updater functions.  A stub unbinds itself, `require's its
  ;; module, then calls the real function -- which works exactly once.
  ;; `mood-line--activate' installs those *symbols* as hooks and as advice on
  ;; `flymake-start' and friends.
  ;;
  ;; When async native compilation finishes, Emacs "late loads" the fresh .eln.
  ;; A late load re-registers every `defun' in the unit (comp.el emits
  ;; `comp--late-register-subr' for each one) while skipping all other
  ;; top-level forms.  So the spent stub is reinstalled on top of the resolved
  ;; function -- and this time its `require' is a no-op, because the module is
  ;; already in `features'.  The next `flymake-start' then dies with
  ;;   (void-function mood-line-segment-checker--flymake-update)
  ;;
  ;; This fires whenever mood-line is rebuilt, and it fired across the board
  ;; when the Emacs 31.1 upgrade invalidated the whole eln cache.  Loading the
  ;; segment modules eagerly is not enough, since the late load still clobbers
  ;; the symbols.  Instead, re-point mood-line's hooks and advice at the real
  ;; *function objects*, which no later symbol redefinition can touch.
  ;;
  ;; `rock/modeline-set' calls this once, right after turning mood-line-mode
  ;; on.  Toggling mood-line back *off* afterwards can leave one of these
  ;; real functions attached to a hook (e.g. flymake's), because
  ;; `mood-line--deactivate' only knows how to remove the original stub
  ;; *symbol*, not the function object this pins in its place.  That stray
  ;; hook only refreshes mood-line's own internal segment cache, which
  ;; nothing reads while mood-line is inactive, so it is harmless noise
  ;; rather than a real leak.
  (defun rock/mood-line-pin-segments ()
    "Pin mood-line's lazy segment updaters to their real definitions."
    (dolist (module '(mood-line-segment-checker mood-line-segment-vc))
      (when-let* ((lib (locate-library (symbol-name module))))
        (load lib :noerror :nomessage)))
    (pcase-dolist (`(,stub . ,hooks) mood-line--hooks-alist)
      (when (fboundp stub)
        (let ((real (symbol-function stub)))
          (dolist (hook hooks)
            (remove-hook hook stub)
            (add-hook hook real)))))
    (pcase-dolist (`(,stub . ,fns) mood-line--advice-alist)
      (when (fboundp stub)
        (let ((real (symbol-function stub)))
          (dolist (fn fns)
            (advice-remove fn stub)
            (advice-add fn :after real))))))

  ;; (custom-set-faces '(mood-line-unimportant ((t (:inherit shadow :weight normal)))))

  ;; Use pretty Fira Code-compatible glyphs
  :custom
  ;; Can't use :setopt
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

;; --------------------------------------------------------------------------
;; sleek-modeline -- actively maintained, the default backend
;; --------------------------------------------------------------------------

(use-package sleek-modeline
  :ensure (sleek-modeline :host github :repo "abidanBrito/sleek-modeline")
  :custom
  ;; Upstream ships the modal badge off; this is the meow state indicator
  ;; that `mood-line-segment-modal' used to provide.
  (sleek-modeline-show-modal-state t)
  ;; Mode-line height comes from a :box line-width.  Keep it minimal so that
  ;; `spacious-padding' (:mode-line-width 6) stays in charge of the padding.
  (sleek-modeline-size 'small)
  ;; Eglot installs its own clickable "[eglot:<project>]" indicator (with
  ;; real mouse-1/mouse-3 menus) directly into `mode-line-misc-info' -- see
  ;; the `rock/sleek-modeline-misc-info' segment below.  Sleek's own `lsp'
  ;; segment would just duplicate that with a plain, non-interactive "LSP".
  (sleek-modeline-enable-lsp nil)

  :config
  ;; The `project' segment checks (featurep 'project) at render time, so a
  ;; buffer visited before anything pulls project.el in would show no project
  ;; name at all.  Load it up front.
  (require 'project nil t)

  ;; ------------------------------------------------------------------
  ;; Segments sleek-modeline does not ship, ported from the mood-line
  ;; format above.  A segment is a function of no arguments returning a
  ;; (propertized) string, or nil to display nothing.
  ;; ------------------------------------------------------------------

  (defun rock/sleek-modeline-buffer-status ()
    "Return an indicator for the state of the current buffer.
Glyphs follow the Fira Code set used with mood-line: `◢' narrowed,
`●' modified, `■' read-only.  Returns nil for an ordinary buffer."
    (let ((file (buffer-file-name (buffer-base-buffer))))
      (cond
       ((buffer-narrowed-p)
        (propertize "◢" 'face (if (buffer-modified-p)
                                  'sleek-modeline-buffer-name-modified-face
                                'shadow)))
       ((and file (buffer-modified-p))
        (propertize "●" 'face 'sleek-modeline-buffer-name-modified-face))
       ((and file buffer-read-only)
        (propertize "■" 'face 'shadow)))))

  (defun rock/sleek-modeline-anzu ()
    "Return the anzu match counter, or nil when no search is running."
    (when (bound-and-true-p anzu--state)
      (propertize
       (cond
        ((eq anzu--state 'replace-query)
         (format "Replace×%d" anzu--cached-count))
        ((bound-and-true-p anzu--overflow-p)
         (format "%d/%d+" anzu--current-position anzu--total-matched))
        (t
         (format "%d/%d" anzu--current-position anzu--total-matched)))
       'face 'mode-line-emphasis)))

  (defun rock/sleek-modeline-multiple-cursors ()
    "Return the number of active cursors, or nil when there is just one."
    (when (bound-and-true-p multiple-cursors-mode)
      (propertize (format "MC×%d" (mc/num-cursors))
                  'face 'mode-line-emphasis)))

  (defun rock/sleek-modeline-cursor-position ()
    "Return the line and column of point."
    (format-mode-line "%l:%c"))

  (defun rock/sleek-modeline-scroll ()
    "Return the position of the viewport in the buffer."
    (format-mode-line "%o" 'shadow))

  (defun rock/sleek-modeline-process ()
    "Return `mode-line-process' when this buffer runs a process."
    (let ((process-info (format-mode-line mode-line-process)))
      (unless (string-blank-p process-info)
        (string-trim process-info))))

  (defun rock/sleek-modeline-misc-info ()
    "Return the rendered value of `mode-line-misc-info'.
This is what surfaces eglot's own clickable [eglot:<project>] indicator
and its mouse-1/mouse-3 menus, since `eglot.el' installs itself straight
into `mode-line-misc-info' rather than going through any mode-line
package.  `format-mode-line' preserves the keymap/mouse-face/help-echo
text properties eglot attaches, so the menus keep working here exactly as
they did in the default mode-line and in mood-line's own `misc-info'
segment.  Anything else that pushes onto `global-mode-string' (e.g. org's
clock) surfaces here too."
    (let ((misc-info (format-mode-line mode-line-misc-info)))
      (unless (string-blank-p misc-info)
        (concat " " (string-trim misc-info)))))

  ;; ------------------------------------------------------------------
  ;; Registration.  `:priority' orders segments within a side, lowest
  ;; first; re-registering a name replaces the upstream segment.
  ;;
  ;;   upstream left   modal-state 0, project 10, buffer-name 20
  ;;   upstream right  diagnostics 0, line-ending 10, vc 20, lsp 30,
  ;;                   major-mode 40
  ;;
  ;; `:separator' is a *suffix* emitted only when the segment returns
  ;; non-nil, so an inactive segment never leaves a dangling separator.
  ;; ------------------------------------------------------------------

  ;; The buffer name is no longer last on the left, so it needs a separator.
  (sleek-modeline-register-segment 'buffer-name
                                   :fn 'sleek-modeline-buffer-name
                                   :side 'left
                                   :priority 20
                                   :separator t)

  (sleek-modeline-register-segment 'buffer-status
                                   :fn 'rock/sleek-modeline-buffer-status
                                   :side 'left
                                   :priority 15
                                   :separator " ")

  (sleek-modeline-register-segment 'anzu
                                   :fn 'rock/sleek-modeline-anzu
                                   :side 'left
                                   :priority 30
                                   :separator t)

  (sleek-modeline-register-segment 'multiple-cursors
                                   :fn 'rock/sleek-modeline-multiple-cursors
                                   :side 'left
                                   :priority 40
                                   :separator t)

  (sleek-modeline-register-segment 'cursor-position
                                   :fn 'rock/sleek-modeline-cursor-position
                                   :side 'left
                                   :priority 50
                                   :separator " ")

  (sleek-modeline-register-segment 'scroll
                                   :fn 'rock/sleek-modeline-scroll
                                   :side 'left
                                   :priority 60)

  ;; Process sits before the major mode so that major-mode stays last on the
  ;; right and an idle buffer never renders a trailing separator.
  (sleek-modeline-register-segment 'process
                                   :fn 'rock/sleek-modeline-process
                                   :side 'right
                                   :priority 35
                                   :separator t)

  ;; Last on the right, mirroring stock Emacs' own `mode-line-format' where
  ;; `mode-line-misc-info' trails `mode-line-modes' (major/minor modes).
  ;; The leading space `rock/sleek-modeline-misc-info' adds stands in for a
  ;; separator, since the built-in `major-mode' segment doesn't add one of
  ;; its own after itself.
  (sleek-modeline-register-segment 'misc-info
                                   :fn 'rock/sleek-modeline-misc-info
                                   :side 'right
                                   :priority 45)

  ;; `rock/modeline-set' calls `sleek-modeline-mode' itself; it is not
  ;; turned on here so that loading this package never overrides whichever
  ;; backend is currently selected.
  )

;; --------------------------------------------------------------------------
;; Toggle
;; --------------------------------------------------------------------------

;; `sleek-modeline' is fetched fresh from GitHub via elpaca's :host recipe, so
;; its first-run clone and build happen asynchronously.  Without this barrier,
;; `rock/modeline-set' below would run before that finishes and fail with
;; "Symbol's function definition is void: sleek-modeline-mode".  Both
;; use-package blocks above already queued their install/build by this point;
;; this just blocks until elpaca's queue actually drains.
(elpaca-wait)

(defun rock/modeline-set (backend)
  "Activate mode-line BACKEND, turning the other one off.
BACKEND is `sleek-modeline' or `mood-line'."
  (interactive
   (list (intern (completing-read "Mode-line backend: "
                                   '("sleek-modeline" "mood-line")
                                   nil t))))
  (pcase backend
    ('mood-line
     (when (bound-and-true-p sleek-modeline-mode) (sleek-modeline-mode -1))
     (mood-line-mode 1)
     (rock/mood-line-pin-segments))
    ('sleek-modeline
     (when (bound-and-true-p mood-line-mode) (mood-line-mode -1))
     (sleek-modeline-mode 1))
    (_ (user-error "Unknown mode-line backend: %s" backend)))
  (setq rock/modeline-backend backend)
  (when (called-interactively-p 'interactive)
    (message "Mode-line backend: %s" backend)))

(defun rock/modeline-toggle ()
  "Toggle between the `sleek-modeline' and `mood-line' backends."
  (interactive)
  (rock/modeline-set (if (eq rock/modeline-backend 'sleek-modeline)
                         'mood-line
                       'sleek-modeline))
  (message "Mode-line backend: %s" rock/modeline-backend))

(rock/modeline-set rock/modeline-backend)

(provide 'modeline-settings)
;;; modeline-settings.el ends here
