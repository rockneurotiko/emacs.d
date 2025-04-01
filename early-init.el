(package-initialize nil)
(setq package-enable-at-startup nil)
(setenv "LSP_USE_PLISTS" "true")
;; (setenv "ESHELL" "/usr/bin/zsh")

;; Ensure Emacs loads the most recent byte-compiled files.
(setq load-prefer-newer t)

;; Make Emacs Native-compile .elc files asynchronously
(setq native-comp-jit-compilation t)
