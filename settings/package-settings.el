;; -*- lexical-binding: t; -*-

(require 'package)

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives
               '("melpa"."http://melpa.org/packages/")))

;; Comment this after first run!
;; (package-refresh-contents)

;; use-package (https://github.com/jwiegley/use-package)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq package-install-upgrade-built-in t)
(require 'use-package)

;; (use-package auto-compile
;;   :ensure t
;;   :config (auto-compile-on-load-mode))

;; (use-package compile-angel
;;   :ensure t
;;   :demand t
;;   :config
;;   ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
;;   ;; (When set to nil, compile-angel won't show which file is being compiled.)
;;   (setq compile-angel-verbose t)

;;   ;; Uncomment the line below to compile automatically when an Elisp file is saved
;;   ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

;;   ;; A global mode that compiles .el files before they are loaded
;;   ;; using `load' or `require'.
;;   (compile-angel-on-load-mode))

;; Quelpa
;; (unless (package-installed-p 'quelpa)
;;   (with-temp-buffer
;;     (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
;;     (eval-buffer)
;;     (quelpa-self-upgrade)))

;; (quelpa
;;  '(quelpa-use-package
;;    :fetcher git
;;    :url "https://github.com/quelpa/quelpa-use-package.git"))
;; (require 'quelpa-use-package)


;; straight

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Secrets
(load "~/.emacs.secrets" t)

(use-package project
  :ensure t)

(use-package diminish
  :ensure t
  :init
  (diminish 'auto-revert-mode)
  (diminish 'eldoc-mode))

;; (defun ensure-package-installed (&rest packages)
;;     "Assure every package is installed, ask for installation if it’s not.

;; Return a list of installed packages or nil for every skipped package."
;;     (mapcar
;;      (lambda (package)
;;          ;; (package-installed-p 'evil)
;;          (if (package-installed-p package)
;;                  nil
;;              (if (y-or-n-p (format "Package %s is missing. Install it? " package))
;;                      (package-install package)
;;                  package)))
;;      packages))

;; ;; make sure to have downloaded archive description.
;; ;; Or use package-archive-contents as suggested by Nicolas Dudebout
;; (or (file-exists-p package-user-dir)
;;     (package-refresh-contents))

;; (ensure-package-installed 'auto-complete 'auto-complete-config 'powerline 'bodil-flycheck 'flycheck 'faces 'go-autocomplete 'auto-complete-config 'compile 'helm 'helm-swoop 'ido 'flx 'flx-ido 'angular-snippets 'web-mode 'ess 'tex-site 'font-latex 'merlin 'ocp-indent 'org-agenda 'ox-reveal 'python 'ein 'pydoc-info 'jedi 'flymake 'virtualenvwrapper 'ensime 'powerline 'moe-theme 'linum 'yasnippet)


(provide 'package-settings)
