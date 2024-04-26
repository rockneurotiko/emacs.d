(require 'org)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO(t)" "PENDING(p)" "MEETING(m)" "|" "DONE(d)" "CANCELED(c)")))

;; Stop org-mode from highjacking shift-cursor keys
(setq org-replace-disputed-keys t)

;; (require 'dash)
;; (setq org-latex-default-packages-alist
;;       (-remove-item
;;        '("" "hyperref" nil)
;;        org-latex-default-packages-alist))

;; ;; Append new packages
;; (add-to-list 'org-latex-default-packages-alist '("" "natbib" "") t)
;; (add-to-list 'org-latex-default-packages-alist
;;              '("linktocpage,pdfstartview=FitH,colorlinks,
;; linkcolor=blue,anchorcolor=blue,
;; citecolor=blue,filecolor=blue,menucolor=blue,urlcolor=blue"
;;                "hyperref" nil)
;;              t)


(setq org-hide-emphasis-markers t)

(defun my-org-autodone (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'my-org-autodone)

(setq org-refile-targets '((nil :level . 1)
                           (org-agenda-files :level . 1)))
(setq-default org-src-fontify-natively t)

;; http://www.farseer.cn/tweak/2014/11/10/org-your-notes/
(setq org-directory "~/docs/org")
(unless (file-exists-p org-directory)
  (make-directory org-directory t))
(setq org-log-done nil)
(setq org-file-apps '((auto-mode . emacs24)
                      ("\\.mp4\\'" . "xdg-open %s")
                      ("\\.pdf\\'" . "xdg-open %s")))
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)
(setq org-default-notes-file "~/docs/org/organizer.org")

(defun rock--org-activate-flyspell ()
  (add-hook 'org-mode-hook 'flyspell-mode))
(rock--org-activate-flyspell)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook
          (lambda ()
            ;; Register " as verbatim
            ;; http://permalink.gmane.org/gmane.emacs.orgmode/82669
            (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n,'")
            (custom-set-variables `(org-emphasis-alist ', org-emphasis-alist))))



(use-package helm-flyspell
  :ensure t
  :config (define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct))


;; This will let us use syntax colors in code blocks
(use-package htmlize
  :ensure t)
;; (use-package ox-reveal
;;   :ensure t
;;   :init (setq org-reveal-root (concat "file://" (expand-file-name "~/.emacs.d/plugins/revealjs"))))

(defun set-ditaa ()
  (setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0_9.jar")
  ;; this line activates ditaa
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ditaa . t))))

(defun enable-beamer ()
  ;; allow for export=>beamer by placing

  ;; #+LaTeX_CLASS: beamer in org files

  (require 'ox-latex)
  (add-to-list 'org-latex-classes
               '("beamer"
                 "\\documentclass\[presentation\]\{beamer\}"
                 ("\\section\{%s\}" . "\\section*\{%s\}")
                 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t))))

(add-to-list 'org-latex-packages-alist '("newfloat" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        ;; "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)


(add-to-list 'org-latex-default-packages-alist '("" "natbib" "") t)

(add-to-list 'org-latex-default-packages-alist
             '("linktocpage,pdfstartview=FitH,colorlinks,
linkcolor=blue,anchorcolor=blue,
citecolor=blue,filecolor=blue,menucolor=blue,urlcolor=blue"
               "hyperref" nil)
             t)

(provide 'org-settings)
