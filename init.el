                                        ; @begin(76331830)@ - Do not edit these lines - added automatically!
(if (file-exists-p "/home/rock/Descargas/temp/CiaoDE-1.15-1781-g328b907/emacs-mode/ciao-site-file.el")
    (load-file "/home/rock/Descargas/temp/CiaoDE-1.15-1781-g328b907/emacs-mode/ciao-site-file.el")
  )
                                        ; @end(76331830)@ - End of automatically added lines.


;; .emacs
(setq user-full-name "Rock Neurotiko"
      user-mail-address (concat "miguelglafuente" "@" "gmail" ".com"))

;; cool frame title with currently edited buffer name
(setq frame-title-format
      (concat "%b - " invocation-name "@" system-name))

(menu-bar-mode -1)
(tool-bar-mode -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-indent-assign-indent-level 4)
 '(custom-safe-themes
   (quote
    ("7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" default)))
 '(elfeed-feeds
   (quote
    ("http://prog21.dadgum.com/atom.xml" "http://syntaxexclamation.wordpress.com/feed/" "http://blog.emillon.org/rss.xml" "http://why-lambda.blogspot.com/feeds/posts/default" "http://sigfpe.blogspot.com/feeds/posts/default" "http://psnively.github.com/atom.xml" "http://edwinb.wordpress.com/feed/" "http://existentialtype.wordpress.com/feed/" "http://brianmckenna.org/blog/feed" "http://queuea9.wordpress.com/feed/" "http://zenzike.com/rss.xml" "http://lambda.jstolarek.com/feed/" "http://monoidal.blogspot.com/feeds/posts/default" "http://spire-lang.org/atom.xml" "http://typesandkinds.wordpress.com/feed/" "http://homotopytypetheory.org/feed/" "http://arcanesentiment.blogspot.com/feeds/posts/default" "http://paolocapriotti.com/atom.xml" "http://semantic-domain.blogspot.com/feeds/posts/default" "http://comonad.com/reader/feed/" "http://jozefg.bitbucket.org/rss.xml" "http://math.andrej.com/feed/" "http://www.lpw25.net/rss.xml" "http://ocaml.janestreet.com/?q=rss.xml" "http://jeremykun.wordpress.com/feed/" "http://twanvl.nl/feed" "http://bartoszmilewski.wordpress.com/feed/" "http://kwangyulseo.com/feed/" "http://www.haskellforall.com/feeds/posts/default" "http://conal.net/blog/feed/" "https://golem.ph.utexas.edu/category/atom10.xml" "http://requestforlogic.blogspot.com/feeds/posts/default" "http://chromaticleaves.com/rss.xml" "http://feeds.feedburner.com/ezyang" "http://raichoo.github.io/feed.rss" "http://bentnib.org/posts.rss.xml" "http://www.simonjf.com/wordpress/?feed=rss2" "http://gallium.inria.fr/~scherer/gagallium/index.rss" "http://anil.recoil.org/feeds/atom.xml" "http://blog.higher-order.com/atom.xml" "http://bitemyapp.com/rss.xml" "http://mazzo.li/rss.xml" "http://infinitecardinals.wordpress.com/feed/" "http://www.stephanboyer.com/feeds/posts/default")))
 '(ido-everywhere t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; MY PATH
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/settings")
;; IRC
(eval-after-load "erc"
    '(progn
     (setq erc-nick "rockneurotiko")
     (setq erc-user-full-name "Rock Neurotiko")
     (setq erc-autojoin-channels-alist
           '(("freenode.net" "#python" "#haskell" "##typetheory" "#scala" "#julia" )))))
(defun my-erc ()
  "Connect IRC with SSL"
  (interactive)
  (erc-tls :server "irc.freenode.net" :port 7000))


(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa"."http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(package-initialize)

;; (add-hook 'after-init-hook (lambda () (load-theme 'spolsky)))
(load-theme 'spolsky t)


;; utf-8 powaa!!
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-input-method nil)
;; no annoying blinking cursor
(blink-cursor-mode -1)
;; default fill column is 70, why?
(setq default-fill-column 79)
;; my sentences end with a dot, not with two spaces
(setq sentence-end-double-space nil)
;; automatically indent wherever I am
(global-set-key (kbd "RET") 'newline-and-indent)
;; set the random number seed from current time and pid
(random t)
;; kill the splash screen before its birth
(setq inhibit-splash-screen t)
;; but give the emacs window a still good shape !
(setq initial-frame-alist '((width . 90) (height . 45))) ; .Xdefaults


;; ido and flx
(require 'ido)
(require 'flx)
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq ido-everywhere 1)
(setq ido-file-extensions-order '(".py" ".org" ".txt" ".cfg" ))
(setq ido-ignore-extensions t)


;; HELM <3
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-buffers-fuzzy-matching           t ; fuzzy matching buffer names when non--nil
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)
(helm-mode 1)

;; Undo properties
(require 'undo-tree)
(global-undo-tree-mode 1)
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-S-z") 'redo)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; js completion
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq ac-js2-evaluate-calls t)

(setq js2-highlight-level 3)

;; web dev
(add-to-list 'auto-mode-alist '("\\.php[345]?\\'\\|\\.inc\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(add-to-list 'auto-mode-alist
             '("\\.p?html\\(\\.[a-z]\\{2\\}\\)?\\'" . html-mode))

;; (load "~/.emacs.d/plugins/tern.el")
;; (load "~/.emacs.d/plugins/tern-auto-complete.el")


;; (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;; (eval-after-load 'tern
;;   '(progn
;;      (require 'tern-auto-complete)
;;      (tern-ac-setup)))

(setq js-indent-level 4)
(setq js2-indent-level 4)

;; (defun delete-tern-process ()
;;   (interactive)
;;   (delete-process "Tern"))

;; outline-mode
;; (add-to-list 'auto-mode-alist '("\\.outline\\'" . outline-mode))
;; (require 'outline-presentation)
;; (add-hook 'outline-presentation-mode-hook
;;           (lambda () (text-scale-increase 3)))


(setq auto-indent-on-visit-file t) ;; If you want auto-indent on for files
(require 'auto-indent-mode)
(auto-indent-global-mode)
(setq tab-width 4)


(defun move-text-internal (arg)
    (cond
     ((and mark-active transient-mark-mode)
      (if (> (point) (mark))
              (exchange-point-and-mark))
      (let ((column (current-column))
            (text (delete-and-extract-region (point) (mark))))
          (forward-line arg)
          (move-to-column column t)
          (set-mark (point))
          (insert text)
          (exchange-point-and-mark)
          (setq deactivate-mark nil)))
     (t
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
          (forward-line)
          (when (or (< arg 0) (not (eobp)))
              (transpose-lines arg))
          (forward-line -1)
          (if (< arg 0)
                  (forward-line -1))
          (indent-according-to-mode)))
     (indent-according-to-mode)))

(defun move-text-down (arg)
    "Move region (transient-mark-mode active) or current line
  arg lines down."
    (interactive "*p")
    (move-text-internal arg))

(defun move-text-up (arg)
    "Move region (transient-mark-mode active) or current line
  arg lines up."
    (interactive "*p")
    (move-text-internal (- arg)))

(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)

;; (defun move-line-up ()
;;   "Move up the current line."
;;   (interactive)
;;   (transpose-lines 1)
;;   (forward-line -2)
;;   (indent-according-to-mode))
;; (defun move-line-down ()
;;   "Move down the current line."
;;   (interactive)
;;   (forward-line 1)
;;   (transpose-lines 1)
;;   (forward-line -1)
;;   (indent-according-to-mode))
;; (global-set-key [(control shift up)]  'move-line-up)
;; (global-set-key [(control shift down)]  'move-line-down)


(require 'autopair)
(autopair-global-mode)
(require 'smooth-scroll)
(require 'smooth-scrolling)

                                        ;(require 'angular-snippets)
                                        ;(eval-after-load "sgml-mode"
                                        ; '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))

;; scrolling settings
                                        ;(setq scroll-preserve-screen-position t)
                                        ;(setq scroll-margin 2)
                                        ;(setq scroll-step 1)


(global-set-key (kbd "M-S-<left>") 'windmove-left)
(global-set-key (kbd "M-S-<right>") 'windmove-right)
(global-set-key (kbd "M-S-<up>") 'windmove-up)
(global-set-key (kbd "M-S-<down>") 'windmove-down)

(global-set-key (kbd "M-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-s-<down>") 'shrink-window)
(global-set-key (kbd "M-s-<up>") 'enlarge-window)

(setq org-log-done 'note)

;; UML
;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

(setq org-plantuml-jar-path
      (expand-file-name "/opt/plantuml/plantuml.jar"))
(load "~/.emacs.d/plugins/plantum-mode.el")

(load "~/.emacs.d/plugins/odf-mode.el")

(load "~/.emacs.d/plugins/emacs-websocket/websocket.el")
(load "~/.emacs.d/plugins/emacs-realtime-markdown-viewer/realtime-markdown-viewer.el")


(load "~/.emacs.d/plugins/web-mode/web-mode.el")
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Guardar sesion
(desktop-save-mode 1)

;; Numero de lineas
(require 'linum)
(global-linum-mode 1)
(setq linum-disabled-modes-list '(mu4e-headers-mode))
(defun linum-on ()
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
    (linum-mode 1)))

;; Autocompletado
(require 'auto-complete)
(global-auto-complete-mode t)

;; GO
(require 'go-autocomplete)
(require 'auto-complete-config)

;; memory
(setq gc-cons-threshold 20000000)

;;JULIA
(load "~/.emacs.d/plugins/ESS/lisp/ess-site.el")
(setq inferior-julia-program-name "julia")

;; SCALA
(require 'scala-settings)


;; Python
(require 'python-settings)

;; ;; Setup for Flymake code checking.
;; (require 'flymake)
;; ;;(require 'auto-complete)
;; ;;(require 'yasnippet)
;; (require 'python-mode)
;; (load-library "flymake-cursor")
;; ;;(elpy-enable)

;; (setq-default python-indent-offset 4)
;; (setq-default indent-tabs-mode nil)

;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; (setq interpreter-mode-alist
;;       (cons '("python" . python-mode)
;;             interpreter-mode-alist)
;;       python-mode-hook
;;       '(lambda () (progn
;;                     (setq python-indent-offset 4)
;;                     (set-variable 'py-smart-indentation nil)
;;                     ;;(set-variable 'indent-tabs-mode nil)
;;                     (setq tab-width 4)
;;                     ;; (setq python-indent 4)
;;                     ;;(highlight-beyond-fill-column)
;;                                         ;(pabbrev-mode)
;;                                         ;(abbrev-mode)
;;                     )
;;          )
;;       )


;; ;; Script that flymake uses to check code. This script must be
;; ;; present in the system path.
;; (setq pycodechecker "pychecker")

;; (when (load "flymake" t)
;;   (defun flymake-pycodecheck-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list pycodechecker (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pycodecheck-init)))

;; (add-hook 'python-mode-hook 'flymake-mode)

;; ;; (add-hook 'python-mode-hook
;; ;;           (lambda ()
;; ;;             (setq indent-tabs-mode t)
;; ;;             (setq tab-width 4)
;; ;;             (setq python-indent 4)))
;; (add-hook 'after-init-hook (lambda () (setq python-indent-offset 4)))

;; (setenv "ESHELL" (expand-file-name "~/bin/eshell"))

;; VirtualEnv
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support
(setq venv-location "~/Envs")




;; My funcs

(add-to-list 'load-path "~/go/src/github.com/dougm/goflymake")
(require 'go-flymake)

;; Ctrl enter, new line
(defun sublime-new-line ()
  "Go to next line and indent wherever you are in a line"
  (interactive)
  (end-of-line)
  (newline-and-indent))
(global-set-key [C-return] 'sublime-new-line)

;; Comment/uncomment region
(defun comment-or-uncomment-region-or-line ()
  "Like comment-or-uncomment-region, but if there's no mark \(that means no
region\) apply comment-or-uncomment to the current line"
  (interactive)
  (if (not mark-active)
      (comment-or-uncomment-region
       (line-beginning-position) (line-end-position))
    (if (< (point) (mark))
        (comment-or-uncomment-region (point) (mark))
      (comment-or-uncomment-region (mark) (point)))))
(global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)

;; (global-aggressive-indent-mode 1)

(require 'indent-guide)
(indent-guide-global-mode)
;;(set-face-background 'indent-guide-face "dimgray")
(setq indent-guide-recursive t)

(require 'smartparens-config)

(require 'multiple-cursors)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; (require 'zone)
;; (zone-when-idle 120)

(require 'helm-swoop)
;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; (global-set-key (kbd "C-r") 'imenu)
;; (global-set-key (kbd "C-S-s") 'isearch-backward-regexp)


(global-set-key (kbd "C-x w") 'elfeed)
(nyan-mode 1)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")


;; Auto package update
;; (require 'auto-package-update)
;; (auto-package-update-maybe)


;; OCAML
(add-to-list 'load-path "/home/rock/.opam/4.01.0/share/emacs/site-lisp")
(add-to-list 'load-path "/home/rock/.opam/4.01.0/bin/")
(require 'merlin)
(require 'ocp-indent)

;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(setq merlin-use-auto-complete-mode t)
(setq merlin-error-after-save nil)

;; (load "~/.emacs.d/plugins/mochi.el")

;; (setq-default indent-tabs-mode nil)
