(require 'package)

(unless (assoc-default "melpa" package-archives)
    (add-to-list 'package-archives
                 '("melpa"."http://melpa.org/packages/")))

(unless (assoc-default "marmalade" package-archives)
    (add-to-list 'package-archives
                 '("marmalade" . "http://marmalade-repo.org/packages/")))

(unless (assoc-default "elpy" package-archives)
    (add-to-list 'package-archives
                 '("elpy" . "http://jorgenschaefer.github.io/packages/")))

;; Comment this after first run!
(package-refresh-contents)

;; use-package (https://github.com/jwiegley/use-package)
(unless (package-installed-p 'use-package)
    (package-install 'use-package))
(setq use-package-verbose t)
(require 'use-package)
(use-package auto-compile
             :ensure t
             :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;; Secrets
(load "~/.emacs.secrets" t)

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

;; (ensure-package-installed 'auto-complete 'auto-complete-config 'powerline 'bodil-flycheck 'flycheck 'faces 'go-autocomplete 'auto-complete-config 'compile 'helm 'helm-config 'helm-swoop 'ido 'flx 'flx-ido 'angular-snippets 'web-mode 'ess 'tex-site 'font-latex 'merlin 'ocp-indent 'org-agenda 'ox-reveal 'python 'ein 'pydoc-info 'jedi 'flymake 'virtualenvwrapper 'ensime 'powerline 'moe-theme 'linum 'yasnippet)


(setq package-enable-at-startup nil)
(package-initialize)

(provide 'package-settings)
