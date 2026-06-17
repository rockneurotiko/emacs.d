;; -*- lexical-binding: t; -*-

;; -------------------------------------------------------------------------------- ;;
;; This early-init.el file was auto-tangled from an orgmode file. (C) Jake B        ;;
;; -------------------------------------------------------------------------------- ;;

;; Garbage Collections
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold 10000000)

;; Compile warnings
;;  (setq warning-minimum-level :emergency)
(setq native-comp-async-report-warnings-errors 'silent) ;; native-comp warning
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
(setq warning-suppress-log-types '((comp) (bytecomp)))
;; Ensure Emacs loads the most recent byte-compiled files.
(setq load-prefer-newer t)

;; Make Emacs Native-compile .elc files asynchronously
(setq native-comp-jit-compilation t)

;; MISC OPTIMIZATIONS ----
;;; optimizations (froom Doom's core.el). See that file for descriptions.
(setq idle-update-delay 1.0)

;; Disabling bidi (bidirectional editing stuff)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)  ; emacs 27 only - disables bidirectional parenthesis

;; https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
;; Emacs will defer fontification until you stop typing. In practice you never notice the delay – the highlighting catches up instantly – but scrolling and typing may feel smoother.
(setq redisplay-skip-fontification-on-input t)

(setq inhibit-startup-echo-area-message (user-login-name))

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

;; Default frame configuration: full screen, good-looking title bar on macOS
(setq frame-resize-pixelwise t)
(menu-bar-mode -1)
(tool-bar-mode -1)                      ; All these tools are in the menu-bar anyway
(setq default-frame-alist '((fullscreen . maximized)

                            ;; You can turn off scroll bars by uncommenting these lines:
                            ;; (vertical-scroll-bars . nil)
                            ;; (horizontal-scroll-bars . nil)

                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated.
                            ;; NOTE: do NOT hardcode background-color here — the
                            ;; frame parameter overrides the theme's `default'
                            ;; face background, so noctalia (#151217) never
                            ;; reaches the frame and TTY terminals fall back to
                            ;; their default/transparent bg. Let the theme set it.
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))

;; https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
(setq read-process-output-max (* 4 1024 1024)) ; 4MB

(setenv "LSP_USE_PLISTS" "true")

;; Window configuration
(setq frame-inhibit-implied-resize t) ;; Supposed to hasten startup

;; Less clutter (this is what dfrosted12 uses so I trust that)
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars))

;; This makes the Aqua titlebar color the same as Emacs.
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Package.el setup
(setq package-enable-at-startup nil)
